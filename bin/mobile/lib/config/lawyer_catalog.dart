import 'package:flutter/material.dart';

/// Women Lawyer practice areas aligned with backend `LawyerCategories`.
class LawyerCatalog {
  LawyerCatalog._();

  static const practiceAreas = [
    'Family Law',
    'Domestic Violence',
    'Divorce & Maintenance',
    'Child Custody',
    'Harassment at Workplace',
    'Property & Inheritance',
    'Cyber Crime',
    'Consumer Rights',
    'Labour & Employment',
    'Criminal Defense',
    'Documentation & Contracts',
    'Legal Aid / Pro Bono',
  ];

  static const consultModes = ['In-person', 'Video', 'Phone', 'Chat'];

  static const cancelPolicy =
      'Free cancellation until 2 hours before the consult. After that the fee is not refunded.';

  static const designations = [
    'Advocate',
    'Senior Advocate',
    'Legal consultant',
    'Legal aid lawyer',
    'In-house counsel',
    'Other',
  ];

  static const audiences = [
    'Women',
    'Families',
    'Survivors of violence',
    'Working professionals',
    'Students',
  ];

  static const facilities = [
    'Private chamber',
    'Waiting area',
    'Wheelchair access',
    'Female staff',
    'Video consult ready',
    'Documents notarised',
    'UPI / card',
  ];

  static const languages = [
    'Hindi',
    'English',
    'Marathi',
    'Gujarati',
    'Tamil',
    'Telugu',
    'Kannada',
    'Bengali',
    'Punjabi',
    'Malayalam',
  ];

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

  static const serviceModes = ['CHAMBER', 'VIDEO', 'BOTH'];

  static const indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Other',
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

  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: 'all', label: 'All Lawyers', icon: Icons.grid_view_rounded),
    (value: 'Family Law', label: 'Family', icon: Icons.family_restroom),
    (value: 'Domestic Violence', label: 'DV', icon: Icons.shield_outlined),
    (value: 'Divorce & Maintenance', label: 'Divorce', icon: Icons.balance),
    (value: 'Child Custody', label: 'Custody', icon: Icons.child_care_outlined),
    (value: 'Harassment at Workplace', label: 'Workplace', icon: Icons.work_outline),
    (value: 'Cyber Crime', label: 'Cyber', icon: Icons.security),
    (value: 'Property & Inheritance', label: 'Property', icon: Icons.home_work_outlined),
    (value: 'Legal Aid / Pro Bono', label: 'Legal Aid', icon: Icons.volunteer_activism_outlined),
  ];

  static List<String> splitAreas(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(RegExp(r'[,|]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static String _norm(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static bool matchesPracticeArea(String? practiceAreas, String filter) {
    if (filter == 'all') return true;
    final cat = _norm(filter);
    if (cat.isEmpty) return true;
    final specs = splitAreas(practiceAreas);
    if (specs.isEmpty) return false;
    for (final spec in specs) {
      final n = _norm(spec);
      if (n == cat || n.contains(cat) || cat.contains(n)) return true;
    }
    return false;
  }
}
