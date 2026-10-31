import 'package:flutter/material.dart';

/// Self-defense / martial arts catalogs — Complete Profile + member filters.
class MartialArtsCatalog {
  MartialArtsCatalog._();

  static const styles = [
    'Karate',
    'Taekwondo',
    'Judo',
    'Kung Fu',
    'Self-Defence',
    'MMA',
    'Boxing',
    'Kickboxing',
    'Muay Thai',
    'Krav Maga',
    'Aikido',
    'Kalaripayattu',
    'Wrestling',
    'Jiu-Jitsu',
    'Other',
  ];

  static const centreTypes = [
    'Academy',
    'Dojo',
    'Training hall',
    'Home studio',
    'Community hall',
    'Outdoor',
  ];

  static const designations = [
    'Owner',
    'Head coach',
    'Manager',
    'Instructor',
  ];

  static const affiliations = [
    'None',
    'WKF',
    'ITF',
    'Shotokan',
    'National body',
    'Other',
  ];

  static const audiences = [
    'Women',
    'Girls (under 16)',
    'Mixed',
    'Men',
  ];

  static const ageGroups = [
    'Kids 6–12',
    'Teens 13–17',
    'Adults 18+',
    '40+',
  ];

  static const facilities = [
    'Mats',
    'Changing room',
    'Washroom',
    'Drinking water',
    'CCTV',
    'First-aid',
    'Parking',
    'AC',
    'Women-only hours',
    'Beginner-friendly',
  ];

  static const offers = [
    'Regular class',
    'Trial class',
    'Belt grading',
    'Workshops',
    'Self-defence crash course',
  ];

  static const skillLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'All levels',
  ];

  static const batchAgeGroups = [
    'Kids',
    'Teens',
    'Adults',
    'All',
  ];

  static const modes = [
    'Offline',
    'Online',
    'Hybrid',
  ];

  static const trialTypes = [
    'None',
    'Free 1 class',
    'Paid trial',
  ];

  static const durations = [45, 60, 90];

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

  static const days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  static const cancelPolicy =
      'Free cancellation until 24 hours before the first class. After that the fee is not refunded. '
      'Batch transfer is allowed once if requested 48 hours in advance.';

  static List<String> splitCsv(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    if (value == null) return [];
    return value
        .toString()
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static TimeOfDay? parseTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parts = raw.trim().split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
  }

  static bool isBatchToday(Map<String, dynamic> batch) {
    final days = splitCsv(batch['availableDays']).map((e) => e.toUpperCase()).toSet();
    if (days.isEmpty) return false;
    const names = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    final today = names[DateTime.now().weekday - 1];
    return days.any((d) => d.startsWith(today.substring(0, 3)) || d == today);
  }

  static bool hasSeats(Map<String, dynamic> batch) {
    final status = batch['status']?.toString().toLowerCase() ?? '';
    if (status == 'full' || status == 'closed') return false;
    final left = batch['seatsLeft'];
    if (left is num) return left > 0;
    return true;
  }
}
