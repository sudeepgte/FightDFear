import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'module_theme.dart';

/// Friendly empty state with icon, title, body, and optional CTA.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4E6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 42, color: ModuleTheme.primary),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: ModuleTheme.textGray, height: 1.45),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Profile completion card with bar + contextual hint.
class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({
    super.key,
    required this.percent,
    required this.statusLabel,
    required this.hint,
    required this.actionLabel,
    required this.onAction,
    this.trailing,
    this.showActionButton = true,
  });

  final double percent;
  final String statusLabel;
  final String hint;
  final String actionLabel;
  final VoidCallback onAction;
  final Widget? trailing;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    final pct = percent.clamp(0, 100);
    final filled = (pct / 10).floor().clamp(0, 10);
    final bar = '${'█' * filled}${'░' * (10 - filled)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: ModuleTheme.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Profile Completion', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(statusLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bar,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              letterSpacing: 1,
              color: pct >= 100 ? const Color(0xFF22C55E) : ModuleTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text('${pct.round()}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          if (hint.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(hint, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13, height: 1.4)),
          ],
          if (trailing != null) ...[const SizedBox(height: 8), trailing!],
          if (showActionButton) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
            ),
          ],
        ],
      ),
    );
  }

  static String hintFromMissing(List<String> missing, {String? guidance}) {
    if (guidance != null && guidance.trim().isNotEmpty) return guidance.trim();
    if (missing.isEmpty) {
      return 'Complete all required sections to submit verification.';
    }
    final first = missing.first;
    final lower = first.toLowerCase();
    if (lower.contains('medical') || lower.contains('license') || lower.contains('registration')) {
      return 'Complete your Medical License to submit verification.';
    }
    if (lower.contains('document') || lower.contains('photo')) {
      return 'Upload required documents to submit verification.';
    }
    return 'Complete $first to submit verification.';
  }
}

/// Sequential loading → success snackbars for async actions.
class ActionFeedback {
  static Future<T?> run<T>(
    BuildContext context, {
    required String loadingLabel,
    required String doneLabel,
    required Future<T> Function() action,
    bool showError = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(loadingLabel)),
          ],
        ),
      ),
    );
    try {
      final result = await action();
      if (!context.mounted) return result;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF166534),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('✔ $doneLabel')),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return result;
    } catch (e) {
      if (context.mounted) {
        messenger.hideCurrentSnackBar();
        if (showError) {
          messenger.showSnackBar(
            SnackBar(content: Text('Something went wrong: $e')),
          );
        }
      }
      rethrow;
    }
  }
}

Future<void> showVerificationSubmittedSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + MediaQuery.paddingOf(ctx).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Text('🎉', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Verification Submitted',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "We'll review your profile within 24–48 hours.\n\n"
            "You'll receive a notification when the review is complete.",
            textAlign: TextAlign.center,
            style: TextStyle(color: ModuleTheme.textGray, height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Back to Dashboard'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> showAppointmentConfirmedSheet(
  BuildContext context, {
  required String doctorName,
  required String dateLabel,
  required String timeLabel,
  required String statusLabel,
  int? doctorId,
  int? appointmentId,
  String? appointmentIso,
  VoidCallback? onJoinChat,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + MediaQuery.paddingOf(ctx).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.event_available, color: Color(0xFF166534)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Appointment Confirmed',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _confirmRow(Icons.person_outline, 'Doctor', doctorName),
          const SizedBox(height: 10),
          _confirmRow(Icons.calendar_today_outlined, 'Date', dateLabel),
          const SizedBox(height: 10),
          _confirmRow(Icons.schedule, 'Time', timeLabel),
          const SizedBox(height: 10),
          _confirmRow(Icons.info_outline, 'Status', statusLabel),
          const SizedBox(height: 24),
          if (onJoinChat != null && doctorId != null)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                onJoinChat();
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Join Chat'),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await _addToCalendar(
                context: ctx,
                title: 'Consultation with $doctorName',
                dateLabel: dateLabel,
                timeLabel: timeLabel,
                appointmentIso: appointmentIso,
                appointmentId: appointmentId,
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Add to Calendar'),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
        ],
      ),
    ),
  );
}

Widget _confirmRow(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: ModuleTheme.primary),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    ],
  );
}

Future<void> _addToCalendar({
  required BuildContext context,
  required String title,
  required String dateLabel,
  required String timeLabel,
  String? appointmentIso,
  int? appointmentId,
}) async {
  final details = StringBuffer()
    ..writeln(title)
    ..writeln('Date: $dateLabel')
    ..writeln('Time: $timeLabel');
  if (appointmentId != null) details.writeln('Appointment #$appointmentId');

  await Clipboard.setData(ClipboardData(text: details.toString()));

  DateTime? start;
  if (appointmentIso != null && appointmentIso.isNotEmpty) {
    start = DateTime.tryParse(appointmentIso.replaceFirst(' ', 'T'));
  }

  if (start != null) {
    final end = start.add(const Duration(minutes: 30));
    String fmt(DateTime d) =>
        '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}'
        'T${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}00';
    final uri = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=${Uri.encodeComponent(title)}'
      '&dates=${fmt(start)}/${fmt(end)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening Google Calendar…')),
        );
      }
      return;
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment details copied — paste into your calendar app')),
    );
  }
}

void showDoctorSetupHelp(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Getting patient bookings'),
      content: const Text(
        '• Complete and submit your profile for admin verification\n'
        '• Turn on Online when you are available\n'
        '• Enable Emergency Available for instant consult discovery\n'
        '• Keep your schedule and fees up to date',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
      ],
    ),
  );
}
