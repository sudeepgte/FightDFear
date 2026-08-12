import 'package:flutter/material.dart';

/// Women Doctor catalogs — specialization must match patient browse filters.
class DoctorCatalog {
  DoctorCatalog._();

  static const specializations = [
    'Gynecologist',
    'Obstetrician',
    'Psychologist',
    'Psychiatrist',
    'General Physician',
    'Dermatologist',
    'Pediatrician',
    'Nutritionist',
    'Fertility Specialist',
    'Endocrinologist',
    'Physiotherapist',
    'Other',
  ];

  static const qualifications = [
    'MBBS',
    'MD',
    'MS',
    'DGO',
    'DNB',
    'BAMS',
    'BHMS',
    'BDS',
    'MDS',
    'PhD',
    'Other',
  ];

  static const languages = [
    'English',
    'Hindi',
    'Kannada',
    'Tamil',
    'Telugu',
    'Marathi',
    'Malayalam',
    'Gujarati',
    'Punjabi',
    'Bengali',
    'Urdu',
  ];

  static const services = [
    'General consultation',
    'Follow-up',
    'Women\'s wellness',
    'Prenatal care',
    'Mental health counselling',
    'Skin consultation',
    'Child health',
    'Diet counselling',
    'Second opinion',
  ];

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

  static const modes = <({String code, String label, IconData icon})>[
    (code: 'CLINIC', label: 'In Clinic', icon: Icons.local_hospital_outlined),
    (code: 'VIDEO', label: 'Video', icon: Icons.videocam_outlined),
    (code: 'ONLINE', label: 'Online / Chat', icon: Icons.chat_bubble_outline),
    (code: 'OFFLINE', label: 'Home Visit', icon: Icons.home_outlined),
  ];

  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: 'all', label: 'All Experts', icon: Icons.grid_view_rounded),
    (value: 'Gynecologist', label: 'Gynecologist', icon: Icons.female),
    (value: 'Psychologist', label: 'Psychologist', icon: Icons.psychology_alt_outlined),
    (value: 'General Physician', label: 'General Physician', icon: Icons.monitor_heart_outlined),
    (value: 'Dermatologist', label: 'Dermatologist', icon: Icons.spa_outlined),
    (value: 'Pediatrician', label: 'Pediatrician', icon: Icons.child_care_outlined),
    (value: 'Nutritionist', label: 'Nutritionist', icon: Icons.restaurant_outlined),
  ];

  static const patientGenders = ['Female', 'Male', 'Other', 'Prefer not to say'];

  static List<String> splitCsv(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    if (value == null) return const [];
    return value
        .toString()
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String _norm(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static bool matchesSpecialization(String? specialization, String filter) {
    if (filter == 'all') return true;
    final cat = _norm(filter);
    if (cat.isEmpty) return true;
    final spec = _norm(specialization ?? '');
    return spec == cat || spec.contains(cat) || cat.contains(spec);
  }

  static List<String> consultationModesOf(Map<String, dynamic> doctor) {
    final fromList = splitCsv(doctor['consultationModes'])
        .map((e) => e.toUpperCase())
        .where((e) => modes.any((m) => m.code == e))
        .toList();
    if (fromList.isNotEmpty) return fromList.toSet().toList();
    final type = (doctor['consultationType']?.toString() ?? '').toUpperCase();
    if (type == 'BOTH') return ['CLINIC', 'VIDEO'];
    if (modes.any((m) => m.code == type)) return [type];
    return modes.map((m) => m.code).toList();
  }

  static String modeLabel(String code) {
    for (final m in modes) {
      if (m.code == code.toUpperCase()) return m.label;
    }
    return code;
  }

  static List<Map<String, String>> parseAvailabilitySlots(dynamic raw) {
    final out = <Map<String, String>>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is! Map) continue;
        final day = item['day']?.toString().trim().toUpperCase() ?? '';
        final start = item['start']?.toString().trim() ?? '';
        final end = item['end']?.toString().trim() ?? '';
        if (day.isEmpty || start.isEmpty || end.isEmpty) continue;
        out.add({'day': day, 'start': start, 'end': end});
      }
      return out;
    }
    return out;
  }

  static TimeOfDay? parseClock(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final m = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw.trim());
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    final min = int.tryParse(m.group(2)!);
    if (h == null || min == null || h > 23 || min > 59) return null;
    return TimeOfDay(hour: h, minute: min);
  }

  static String weekdayName(int weekday) {
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[weekday - 1];
  }

  static String weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  static String weekdayKey(int weekday) => weekdayName(weekday).toUpperCase();

  /// Dates the doctor actually works, including today when a later slot remains.
  static List<DateTime> bookableDates(Map<String, dynamic> doctor, {int daysAhead = 14}) {
    final slots = parseAvailabilitySlots(doctor['availabilitySlots']);
    final allowed = <String>{};
    if (slots.isNotEmpty) {
      allowed.addAll(slots.map((s) => s['day']!));
    } else {
      allowed.addAll(splitCsv(doctor['availableDays']).map((e) => e.toUpperCase()));
    }
    final out = <DateTime>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i <= daysAhead && out.length < 10; i++) {
      final d = today.add(Duration(days: i));
      if (isBlockedDate(doctor, d)) continue;
      if (allowed.isNotEmpty && !allowed.contains(weekdayKey(d.weekday))) continue;
      if (timesForDate(doctor, d).isEmpty) continue;
      out.add(d);
    }
    return out;
  }

  static int slotDurationOf(Map<String, dynamic> doctor) {
    final v = doctor['slotDurationMinutes'];
    if (v is num && v >= 10) return v.toInt();
    return int.tryParse('$v') ?? 30;
  }

  static int bufferOf(Map<String, dynamic> doctor) {
    final v = doctor['bufferMinutes'];
    if (v is num && v >= 0) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static bool isBlockedDate(Map<String, dynamic> doctor, DateTime date) {
    final key =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final raw = doctor['blockedDates'];
    final days = splitCsv(raw);
    return days.contains(key);
  }

  static bool _inBreak(Map<String, dynamic> doctor, TimeOfDay t) {
    final start = parseClock(doctor['breakStart']?.toString());
    final end = parseClock(doctor['breakEnd']?.toString());
    if (start == null || end == null) return false;
    final m = _mins(t);
    return m >= _mins(start) && m < _mins(end);
  }

  /// Per-day hours from availability slots (falls back to startTime/endTime).
  static List<TimeOfDay> timesForDate(Map<String, dynamic> doctor, DateTime date) {
    final day = weekdayKey(date.weekday);
    final slots = parseAvailabilitySlots(doctor['availabilitySlots'])
        .where((s) => s['day'] == day)
        .toList();
    final windows = <({TimeOfDay start, TimeOfDay end})>[];
    if (slots.isNotEmpty) {
      for (final s in slots) {
        final start = parseClock(s['start']);
        final end = parseClock(s['end']);
        if (start == null || end == null) continue;
        if (_mins(end) <= _mins(start)) continue;
        windows.add((start: start, end: end));
      }
    } else {
      final start = parseClock(doctor['startTime']?.toString());
      final end = parseClock(doctor['endTime']?.toString());
      if (start != null && end != null && _mins(end) > _mins(start)) {
        windows.add((start: start, end: end));
      }
    }
    if (isBlockedDate(doctor, date)) return const [];
    final step = slotDurationOf(doctor) + bufferOf(doctor);
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final cutoff = now.add(const Duration(minutes: 15));
    final times = <TimeOfDay>[];
    for (final w in windows) {
      var mins = _mins(w.start);
      final endMins = _mins(w.end);
      while (mins + slotDurationOf(doctor) <= endMins) {
        final t = TimeOfDay(hour: mins ~/ 60, minute: mins % 60);
        if (_inBreak(doctor, t)) {
          mins += step;
          continue;
        }
        if (isToday) {
          final slotDt = DateTime(date.year, date.month, date.day, t.hour, t.minute);
          if (slotDt.isBefore(cutoff)) {
            mins += step;
            continue;
          }
        }
        times.add(t);
        mins += step;
      }
    }
    return times;
  }

  static int _mins(TimeOfDay t) => t.hour * 60 + t.minute;

  static String formatAppt(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:00';
  }

  static String composeReason({
    required String patientName,
    required String age,
    required String gender,
    required String symptoms,
  }) {
    final header = [
      patientName.trim(),
      if (age.trim().isNotEmpty) '${age.trim()} yrs',
      if (gender.trim().isNotEmpty) gender.trim(),
    ].join(' · ');
    final body = symptoms.trim();
    if (header.isEmpty) return body;
    if (body.isEmpty) return header;
    return '$header\n$body';
  }
}
