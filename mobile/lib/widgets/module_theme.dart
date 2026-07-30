import 'package:flutter/material.dart';

class ModuleTheme {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  static List<Map<String, dynamic>> toList(dynamic raw) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static String mediaUrl(String baseUrl, String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path';
  }

  static Widget loading() => const Center(child: CircularProgressIndicator());

  static Widget errorView(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
