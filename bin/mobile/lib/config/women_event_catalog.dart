import 'package:flutter/material.dart';

/// Women Events categories aligned with backend `WomenEventCategory`.
class WomenEventCatalog {
  WomenEventCatalog._();

  static const categories = <({String code, String label})>[
    (code: 'HEALTH_WELLNESS', label: 'Health & Wellness'),
    (code: 'ENTREPRENEURSHIP_CAREER', label: 'Entrepreneurship & Career'),
    (code: 'FITNESS_SPORTS', label: 'Fitness & Sports'),
    (code: 'EDUCATION_SKILLS', label: 'Education & Skills'),
    (code: 'SOCIAL_COMMUNITY', label: 'Social & Community'),
    (code: 'SAFETY_AWARENESS', label: 'Safety & Awareness'),
  ];

  static const organizerTypes = [
    'NGO',
    'Company',
    'Educational Institution',
    'Government Department',
    'Community Organization',
    'Women Self Help Group',
    'Startup',
    'Fitness Organization',
    'Healthcare Organization',
    'Event Management Company',
    'Charity Foundation',
    'Sports Club',
    'Youth Organization',
  ];

  static String labelFor(String? codeOrLabel) {
    if (codeOrLabel == null || codeOrLabel.isEmpty) return 'Event';
    for (final c in categories) {
      if (c.code == codeOrLabel || c.label == codeOrLabel) return c.label;
    }
    return codeOrLabel;
  }

  static String? codeFor(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final c in categories) {
      if (c.code == raw || c.label == raw) return c.code;
    }
    return null;
  }

  static List<String> splitCodes(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => codeFor(s) ?? s)
        .toList();
  }

  static List<String> get expertise => categories.map((c) => c.label).toList();

  static const cancelPolicy =
      'Unpaid tickets can be cancelled anytime. Paid tickets can be cancelled until 2 hours before start. Checked-in tickets cannot be cancelled.';

  static const designations = organizerTypes;

  static const audiences = [
    'Women',
    'Students',
    'Professionals',
    'Entrepreneurs',
    'Families',
    'NGOs',
    'Startups',
    'Community groups',
  ];

  static const facilities = [
    'Parking',
    'Food Court',
    'Drinking Water',
    'Security',
    'Medical Support',
    'Wheelchair Access',
    'Child Care',
    'Washrooms',
    'Wi-Fi',
    'Photography',
  ];

  static const sessionModes = ['Offline', 'Online', 'Hybrid'];

  static const days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  static const durations = [30, 45, 60, 90, 120];

  static const buffers = [0, 5, 10, 15, 20, 30];

  static const indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Delhi',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
    'Mizoram', 'Nagaland', 'Odisha', 'Puducherry', 'Punjab', 'Rajasthan', 'Sikkim',
    'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal', 'Other',
  ];

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static List<String> splitCsv(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    if (raw == null) return [];
    return raw
        .toString()
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static TimeOfDay? parseTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parts = raw.trim().split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }
}
