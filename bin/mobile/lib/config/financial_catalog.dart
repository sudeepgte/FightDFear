import 'package:flutter/material.dart';

class FinancialCatalog {
  FinancialCatalog._();

  static const expertise = [
    'Saving',
    'Investing',
    'Loans',
    'Banking',
    'Insurance',
    'Government Schemes',
  ];

  static const loanTypes = [
    'Personal',
    'Education',
    'Business',
    'Home',
    'Gold',
  ];

  static const cancelPolicy =
      'Free cancellation until 2 hours before the session. After that the fee is not refunded.';

  static const designations = [
    'Certified educator',
    'SEBI RIA',
    'NISM certified',
    'Banker',
    'Insurance advisor',
    'CFP',
    'Other',
  ];

  static const audiences = [
    'Women',
    'Families',
    'First-time investors',
    'Working professionals',
    'Students',
    'Small business owners',
  ];

  static const facilities = [
    'Video studio',
    'In-person workshop',
    'Vernacular sessions',
    '1:1 coaching',
    'UPI / card',
    'Notes PDF',
  ];

  static const sessionModes = ['Live', 'Workshop', '1:1'];

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
