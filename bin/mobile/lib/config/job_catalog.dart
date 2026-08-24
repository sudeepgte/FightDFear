import 'package:flutter/material.dart';

/// Canonical worker job categories + subcategories (apply + user Workers chips).
class JobCatalog {
  JobCatalog._();

  static const categories = <String>[
    'Caregiver',
    'Babysitting',
    'Housekeeping',
    'Cooking',
    'Beauty & Salon',
    'Healthcare',
    'Teaching',
    'Office Jobs',
    'Retail',
    'Hospitality',
    'Customer Support',
    'Delivery & Logistics',
    'Domestic Help',
    'Tailoring & Fashion',
    'Digital Jobs',
    'Freelancing',
    'Entrepreneurship',
  ];

  static const subcategories = <String, List<String>>{
    'Caregiver': ['Elderly Caregiver', 'Patient Care Assistant', 'Child Caregiver', 'Home Care Assistant'],
    'Babysitting': ['Babysitter', 'Nanny', 'Daycare Assistant'],
    'Housekeeping': ['House Maid', 'Housekeeper', 'Cleaner'],
    'Cooking': ['Home Cook', 'Personal Cook', 'Kitchen Assistant'],
    'Beauty & Salon': ['Beautician', 'Hair Stylist', 'Makeup Artist', 'Nail Technician'],
    'Healthcare': ['Nurse', 'Care Assistant', 'Receptionist', 'Lab Assistant'],
    'Teaching': ['Tutor', 'School Teacher', 'Preschool Teacher'],
    'Office Jobs': ['Receptionist', 'Office Assistant', 'Data Entry Operator'],
    'Retail': ['Cashier', 'Sales Executive', 'Store Assistant'],
    'Hospitality': ['Hotel Receptionist', 'Housekeeping Staff', 'Waitress'],
    'Customer Support': ['Call Center Executive', 'Customer Care Representative'],
    'Delivery & Logistics': ['Parcel Coordinator', 'Delivery Executive (where applicable)'],
    'Domestic Help': ['Laundry Assistant', 'Home Helper'],
    'Tailoring & Fashion': ['Tailor', 'Boutique Assistant', 'Fashion Designer'],
    'Digital Jobs': ['Content Writer', 'Graphic Designer', 'Social Media Executive'],
    'Freelancing': ['Virtual Assistant', 'Translator', 'Online Tutor'],
    'Entrepreneurship': ['Sell Handmade Products', 'Home Bakery', 'Boutique Owner'],
  };

  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: 'all', label: 'All Workers', icon: Icons.grid_view_rounded),
    (value: 'Caregiver', label: 'Caregiver', icon: Icons.favorite_outline),
    (value: 'Babysitting', label: 'Babysitting', icon: Icons.child_care_outlined),
    (value: 'Housekeeping', label: 'Housekeeping', icon: Icons.cleaning_services_outlined),
    (value: 'Cooking', label: 'Cooking', icon: Icons.soup_kitchen_outlined),
    (value: 'Beauty & Salon', label: 'Beauty', icon: Icons.spa_outlined),
    (value: 'Teaching', label: 'Teaching', icon: Icons.school_outlined),
    (value: 'Office Jobs', label: 'Office', icon: Icons.work_outline),
    (value: 'Tailoring & Fashion', label: 'Tailoring', icon: Icons.content_cut),
    (value: 'Digital Jobs', label: 'Digital', icon: Icons.laptop_mac_outlined),
    (value: 'Freelancing', label: 'Freelance', icon: Icons.handshake_outlined),
  ];

  static List<String> subsFor(String? category) {
    if (category == null) return const [];
    return subcategories[normalize(category) ?? category] ?? const [];
  }

  static String? normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final t = raw.trim();
    for (final c in categories) {
      if (c.toLowerCase() == t.toLowerCase()) return c;
    }
    return t;
  }

  static String labelFor(String? raw) => normalize(raw) ?? (raw ?? 'Job');

  static const cancelPolicy =
      'Free cancellation until 2 hours before the visit. After that the fee is not refunded.';

  static const designations = [
    'Worker',
    'Caregiver',
    'Babysitter',
    'Cook',
    'Housekeeper',
    'Beautician',
    'Tutor',
    'Tailor',
    'Office assistant',
    'Other',
  ];

  static const audiences = [
    'Women',
    'Families',
    'Elderly',
    'Kids',
    'Working professionals',
  ];

  static const facilities = [
    'Own tools',
    'ID proof',
    'Police verification',
    'First aid trained',
    'Can travel',
    'Night available',
    'Weekend available',
    'UPI / cash',
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

  static const skills = [
    'Cooking',
    'Cleaning',
    'Child care',
    'Elder care',
    'Tutoring',
    'Sewing',
    'Makeup',
    'Hair styling',
    'Driving',
    'Computer basics',
  ];

  static const workTypes = ['Full time', 'Part time', 'Hourly', 'Live-in', 'On demand'];

  static const days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  static const durations = [30, 45, 60, 90, 120, 180];

  static const buffers = [0, 5, 10, 15, 20, 30];

  static const serviceModes = ['DOOR', 'CENTRE', 'BOTH'];

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
}
