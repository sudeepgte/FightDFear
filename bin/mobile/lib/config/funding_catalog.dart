import 'package:flutter/material.dart';

/// Shared proposal categories for Entrepreneur create + Investor market filters.
class FundingCatalog {
  FundingCatalog._();

  static const categories = <String>[
    'Food',
    'Fashion',
    'Technology',
    'Education',
    'Healthcare',
    'Beauty',
    'Handicrafts',
    'Retail',
    'Services',
  ];

  static const cancelPolicy =
      'Pending interest can be withdrawn anytime. Meetings are free to cancel until 2 hours before. Released funds are not refunded.';

  static const entrepreneurDesignations = [
    'Founder',
    'Co-founder',
    'CEO',
    'Managing partner',
    'Other',
  ];

  static const investorDesignations = [
    'Angel',
    'VC',
    'Family office',
    'Syndicate',
    'Other',
  ];

  static const entrepreneurAudiences = [
    'Women',
    'Families',
    'Working professionals',
    'Students',
    'Small business owners',
    'Rural communities',
  ];

  static const investorAudiences = [
    'Pre-seed',
    'Seed',
    'Early stage',
    'Women-led',
    'Social impact',
    'Growth',
  ];

  static const entrepreneurFacilities = [
    'Office',
    'Workshop',
    'Video pitch ready',
    'UPI / card',
    'In-person meetings',
    'Deck PDF',
  ];

  static const investorFacilities = [
    'Video meetings',
    'In-person meetings',
    'Term sheet ready',
    'Follow-on capital',
    'Mentorship',
  ];

  static const raiseModes = ['Equity', 'Debt', 'Grant', 'Revenue share'];
  static const ticketModes = ['Angel', 'Seed', 'Series', 'Grant'];

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

  static String labelFor(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'Startup';
    final t = raw.trim();
    for (final c in categories) {
      if (c.toLowerCase() == t.toLowerCase()) return c;
    }
    return t;
  }

  static String? normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final t = raw.trim();
    for (final c in categories) {
      if (c.toLowerCase() == t.toLowerCase()) return c;
    }
    return t;
  }

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
