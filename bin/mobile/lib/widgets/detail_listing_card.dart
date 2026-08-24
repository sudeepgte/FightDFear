import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'module_theme.dart';

class DetailTag {
  const DetailTag({
    required this.label,
    this.icon,
    this.background = const Color(0xFFF1F5F9),
    this.foreground = const Color(0xFF334155),
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
}

/// Rich listing card matching web doctor/expert cards (avatar, tags, media actions, CTA).
class DetailListingCard extends StatelessWidget {
  const DetailListingCard({
    super.key,
    required this.title,
    this.eyebrow,
    this.location,
    this.photoUrl,
    this.tags = const [],
    this.onPrimary,
    this.primaryLabel = 'View Profile & Book',
    this.phone,
    this.showMediaActions = true,
    this.onChat,
    this.onCall,
    this.onVideo,
    this.chatLabel = 'Chat',
    this.callLabel = 'Call',
    this.videoLabel = 'Video',
    this.chatIcon = Icons.chat_bubble_outline,
    this.callIcon = Icons.call_outlined,
    this.videoIcon = Icons.videocam_outlined,
    this.showVideoAction = true,
  });

  final String title;
  final String? eyebrow;
  final String? location;
  final String? photoUrl;
  final List<DetailTag> tags;
  final VoidCallback? onPrimary;
  final String primaryLabel;
  final String? phone;
  final bool showMediaActions;
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  final VoidCallback? onVideo;
  final String chatLabel;
  final String callLabel;
  final String videoLabel;
  final IconData chatIcon;
  final IconData callIcon;
  final IconData videoIcon;
  final bool showVideoAction;

  Future<void> _launchPhone() async {
    final raw = phone?.trim() ?? '';
    if (raw.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: raw);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final initial = title.trim().isEmpty ? '?' : title.trim().characters.first.toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(photoUrl: photoUrl, initial: initial),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
                      Text(
                        eyebrow!.toUpperCase(),
                        style: const TextStyle(
                          color: ModuleTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: ModuleTheme.navy,
                      ),
                    ),
                    if (location != null && location!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: ModuleTheme.textGray),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location!,
                              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: t.background,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (t.icon != null) ...[
                        Icon(t.icon, size: 13, color: t.foreground),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        t.label,
                        style: TextStyle(
                          color: t.foreground,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          if (showMediaActions) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MediaButton(
                    icon: chatIcon,
                    label: chatLabel,
                    onTap: onChat ??
                        () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chat opens after booking confirmation')),
                            ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MediaButton(
                    icon: callIcon,
                    label: callLabel,
                    onTap: onCall ??
                        () {
                          if (phone != null && phone!.trim().isNotEmpty) {
                            _launchPhone();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Phone number not available')),
                            );
                          }
                        },
                  ),
                ),
                if (showVideoAction) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MediaButton(
                      icon: videoIcon,
                      label: videoLabel,
                      onTap: onVideo ??
                          () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Video consult opens after booking')),
                              ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          if (onPrimary != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [ModuleTheme.navy, ModuleTheme.primary],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: onPrimary,
                    child: Center(
                      child: Text(
                        primaryLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl, required this.initial});
  final String? photoUrl;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 64,
        height: 64,
        color: const Color(0xFFFFE4E6),
        alignment: Alignment.center,
        child: url.isEmpty
            ? Text(
                initial,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: ModuleTheme.primary,
                ),
              )
            : ModuleTheme.networkImage(
                url,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                error: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: ModuleTheme.primary,
                  ),
                ),
              ),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  const _MediaButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: ModuleTheme.navy,
        side: const BorderSide(color: Color(0xFFCBD5E1)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class CategoryPillBar extends StatelessWidget {
  const CategoryPillBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<({String value, String label, IconData icon})> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final o = options[i];
          final active = o.value == selected;
          return FilterChip(
            selected: active,
            showCheckmark: false,
            avatar: Icon(o.icon, size: 16, color: active ? Colors.white : ModuleTheme.textGray),
            label: Text(o.label),
            labelStyle: TextStyle(
              color: active ? Colors.white : ModuleTheme.navy,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            selectedColor: ModuleTheme.navy,
            backgroundColor: Colors.white,
            side: BorderSide(color: active ? ModuleTheme.navy : const Color(0xFFCBD5E1)),
            onSelected: (_) => onSelected(o.value),
          );
        },
      ),
    );
  }
}
