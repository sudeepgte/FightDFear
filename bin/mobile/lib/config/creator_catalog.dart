import 'package:flutter/material.dart';

class CreatorCatalog {
  CreatorCatalog._();

  static const categories = [
    'Safety Awareness',
    'Entrepreneurship',
    'Financial Literacy',
    'Skill Development',
    'Inspirational',
    'Entertainment',
  ];

  static List<String> get expertise => categories;

  static const cancelPolicy =
      'Public videos are free. Tips and paid unlocks are not refundable. Subscriptions can be cancelled anytime; access lasts until the period ends.';

  static const designations = [
    'Creator',
    'Educator',
    'Influencer',
    'Other',
  ];

  static const organizerTypes = designations;

  static const audiences = [
    'Women',
    'Students',
    'Professionals',
    'Families',
    'Creators',
    'Community groups',
  ];

  static const facilities = [
    'Home studio',
    'Lighting',
    'Mic / audio',
    'Editing desk',
    'Vernacular',
    'Live streaming',
  ];

  static const sessionModes = ['Public', 'Subscriber', 'Paid'];

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
