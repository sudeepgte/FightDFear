import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/investor_auth_service.dart';
import 'entrepreneur_funding_screen.dart';
import 'funding_chat_threads_screen.dart';
import 'funding_meetings_screen.dart';
import 'funding_notifications_screen.dart';
import 'funding_pitch_deck_screen.dart';

const Color _primary = Color(0xFFF43F5E);
const Color _navy = Color(0xFF1E1B4B);
const Color _muted = Color(0xFF64748B);

/// Modal bottom sheet with funding collaboration shortcuts.
Future<void> showFundingMenuSheet(
  BuildContext context, {
  required bool isEntrepreneur,
  VoidCallback? onProfile,
  bool showSubscribe = true,
  int? proposalId,
  List<Map<String, dynamic>>? proposals,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      final items = <_FundingMenuItem>[
        if (isEntrepreneur)
          _FundingMenuItem(
            icon: Icons.picture_as_pdf_outlined,
            label: 'Pitch Deck',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              Navigator.pop(sheetCtx);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FundingPitchDeckScreen(
                    proposals: proposals,
                    initialProposalId: proposalId,
                  ),
                ),
              );
            },
          ),
        _FundingMenuItem(
          icon: Icons.event_available_outlined,
          label: 'Meetings',
          color: const Color(0xFF16A34A),
          onTap: () {
            Navigator.pop(sheetCtx);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FundingMeetingsScreen(
                  isEntrepreneur: isEntrepreneur,
                  proposalId: proposalId,
                ),
              ),
            );
          },
        ),
        _FundingMenuItem(
          icon: Icons.chat_bubble_outline,
          label: 'Chat',
          color: const Color(0xFF3B82F6),
          onTap: () {
            Navigator.pop(sheetCtx);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FundingChatThreadsScreen(
                  isEntrepreneur: isEntrepreneur,
                ),
              ),
            );
          },
        ),
        if (isEntrepreneur)
          _FundingMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Released Funds',
            color: const Color(0xFFEF4444),
            onTap: () {
              Navigator.pop(sheetCtx);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EntrepreneurFundingScreen(),
                ),
              );
            },
          ),
        _FundingMenuItem(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          color: const Color(0xFFF97316),
          onTap: () {
            Navigator.pop(sheetCtx);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FundingNotificationsScreen(
                  isEntrepreneur: isEntrepreneur,
                ),
              ),
            );
          },
        ),
        if (isEntrepreneur)
          _FundingMenuItem(
            icon: Icons.person_outline,
            label: 'Profile',
            color: _navy,
            onTap: () {
              Navigator.pop(sheetCtx);
              if (onProfile != null) {
                onProfile();
              }
            },
          ),
        if (!isEntrepreneur && showSubscribe)
          _FundingMenuItem(
            icon: Icons.workspace_premium_outlined,
            label: 'Subscribe',
            color: _primary,
            onTap: () async {
              Navigator.pop(sheetCtx);
              await _subscribeInvestor(context);
            },
          ),
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEntrepreneur ? 'Entrepreneur tools' : 'Investor tools',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Funding collaboration shortcuts',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
              const SizedBox(height: 14),
              ...items.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.color, size: 20),
                  ),
                  title: Text(
                    item.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: _muted),
                  onTap: item.onTap,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _subscribeInvestor(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final svc = InvestorAuthService(context.read<AuthState>().api);
    final res = await svc.subscribe();
    if (!context.mounted) return;
    if (res['success'] == true) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            res['message']?.toString() ?? 'Subscription activated',
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(res['error']?.toString() ?? 'Subscribe failed'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}

class _FundingMenuItem {
  const _FundingMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}
