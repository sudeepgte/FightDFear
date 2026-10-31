import 'package:flutter/material.dart';

/// Fitness trainer categories aligned with backend `FitnessCategories`.
class FitnessCatalog {
  FitnessCatalog._();

  static const allSpecializations = [
    'Gym Training',
    'Zumba',
    'Dance Fitness',
    'Yoga',
    'Aerobics',
    'Pilates',
    'Strength Training',
    'Cardio Training',
    'CrossFit',
    'Functional Training',
    'HIIT',
    'Weight Loss Programs',
    'Weight Gain Programs',
    'Personal Training',
    'Prenatal & Postnatal Fitness',
    'Meditation & Mindfulness',
    'Nutrition & Diet Consultation',
    'Home Workout Sessions',
  ];

  /// Browse filter chips shown to members.
  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: 'all', label: 'All Trainers', icon: Icons.grid_view_rounded),
    (value: 'Yoga', label: 'Yoga', icon: Icons.self_improvement),
    (value: 'HIIT', label: 'HIIT', icon: Icons.fitness_center),
    (value: 'Zumba', label: 'Zumba', icon: Icons.music_note),
    (value: 'Strength Training', label: 'Strength', icon: Icons.sports_gymnastics),
    (value: 'Personal Training', label: 'Personal', icon: Icons.person_outline),
    (value: 'Pilates', label: 'Pilates', icon: Icons.accessibility_new),
    (value: 'CrossFit', label: 'CrossFit', icon: Icons.sports),
  ];

  static List<String> splitSpecializations(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static String _norm(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static const cancelPolicy =
      'Pending unpaid bookings can be cancelled anytime. Paid sessions can be cancelled until 2 hours before start. Completed sessions cannot be cancelled.';

  static const designations = [
    'Personal Trainer',
    'Yoga Instructor',
    'Zumba Instructor',
    'Strength Coach',
    'Pilates Instructor',
    'Group Fitness Instructor',
    'Nutrition Coach',
    'Prenatal & Postnatal Coach',
    'HIIT Coach',
    'Dance Fitness Instructor',
  ];

  static const audiences = [
    'Women',
    'Beginners',
    'Seniors',
    'Athletes',
    'Weight loss',
    'Prenatal',
    'Postnatal',
    'Home workout',
    'Gym members',
  ];

  static const facilities = [
    'Gym floor',
    'Yoga studio',
    'Changing room',
    'Parking',
    'Drinking Water',
    'Mats provided',
    'Home visit',
    'Online classes',
    'Washrooms',
    'Wi-Fi',
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

  static bool matchesCategory(String? specializations, String category) {
    if (category == 'all') return true;
    final cat = _norm(category);
    if (cat.isEmpty) return true;
    final specs = splitSpecializations(specializations);
    if (specs.isEmpty) return false;
    for (final spec in specs) {
      final n = _norm(spec);
      if (n == cat || n.contains(cat) || cat.contains(n)) return true;
      // HIIT chip vs "HIIT (High-Intensity Interval Training)" stored value
      if (cat == 'hiit' && n.contains('hiit')) return true;
      if (cat == 'strength training' && n.contains('strength')) return true;
    }
    return false;
  }
}
