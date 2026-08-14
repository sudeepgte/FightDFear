import 'package:flutter/material.dart';

/// Glow Space service taxonomy — shared by explore, signup, and salon dashboard.
class GlowCategory {
  const GlowCategory({
    required this.code,
    required this.label,
    required this.icon,
    required this.services,
    this.description = '',
  });

  final String code;
  final String label;
  final IconData icon;
  final String description;
  final List<String> services;
}

class GlowCatalog {
  GlowCatalog._();

  static const categories = <GlowCategory>[
    GlowCategory(
      code: 'HAIR',
      label: 'Hair Services',
      icon: Icons.content_cut,
      description: 'Cuts, colour, spa, styling and hair treatments',
      services: [
        'Hair Cut (Women)',
        'Hair Trim',
        'Hair Wash',
        'Hair Blow Dry',
        'Hair Styling',
        'Hair Straightening',
        'Hair Smoothening',
        'Hair Rebonding',
        'Hair Spa',
        'Hair Coloring',
        'Hair Highlights',
        'Global Hair Color',
        'Root Touch-Up',
        'Hair Botox',
        'Hair Keratin Treatment',
        'Hair Extensions',
        'Hair Curling',
        'Hair Perming',
        'Hair Repair Treatment',
        'Scalp Treatment',
        'Dandruff Treatment',
        'Hair Fall Treatment',
        'Bridal Hair Styling',
        'Party Hair Styling',
      ],
    ),
    GlowCategory(
      code: 'SKIN_CARE',
      label: 'Skin Care',
      icon: Icons.face_retouching_natural,
      description: 'Facials, clean-ups, peels and skin treatments',
      services: [
        'Facial',
        'Gold Facial',
        'Diamond Facial',
        'Fruit Facial',
        'Anti-Aging Facial',
        'Hydrating Facial',
        'Acne Treatment',
        'Skin Brightening',
        'Skin Polishing',
        'De-Tan',
        'Clean-Up',
        'Bleach',
        'Chemical Peel',
        'Microdermabrasion',
        'Hydra Facial',
        'Skin Consultation',
      ],
    ),
    GlowCategory(
      code: 'MAKEUP',
      label: 'Makeup',
      icon: Icons.brush_outlined,
      description: 'Bridal, party, HD and fashion makeup',
      services: [
        'Bridal Makeup',
        'Engagement Makeup',
        'Reception Makeup',
        'Party Makeup',
        'HD Makeup',
        'Airbrush Makeup',
        'Fashion Makeup',
        'Natural Makeup',
        'Editorial Makeup',
        'Celebrity Makeup',
        'Saree Draping',
        'Bridal Dressing',
        'Grooming Consultation',
      ],
    ),
    GlowCategory(
      code: 'NAIL_CARE',
      label: 'Nail Care',
      icon: Icons.back_hand_outlined,
      description: 'Manicure, pedicure, gel and nail art',
      services: [
        'Manicure',
        'Pedicure',
        'Gel Manicure',
        'Gel Pedicure',
        'Nail Art',
        'Nail Extensions',
        'Acrylic Nails',
        'Gel Nail Extensions',
        'Nail Repair',
        'Nail Polish Change',
        'French Manicure',
        'Nail Removal',
        'Cuticle Care',
      ],
    ),
    GlowCategory(
      code: 'SPA_MASSAGE',
      label: 'Spa & Massage',
      icon: Icons.spa_outlined,
      description: 'Full body spa, massage and relaxation therapy',
      services: [
        'Full Body Spa',
        'Swedish Massage',
        'Deep Tissue Massage',
        'Aroma Therapy',
        'Hot Stone Massage',
        'Head Massage',
        'Foot Massage',
        'Neck & Shoulder Massage',
        'Relaxation Therapy',
        'Body Polish',
        'Body Scrub',
        'Steam Therapy',
        'Spa Package',
      ],
    ),
    GlowCategory(
      code: 'WAXING',
      label: 'Waxing',
      icon: Icons.water_drop_outlined,
      description: 'Body and face waxing services',
      services: [
        'Full Body Wax',
        'Full Arms Wax',
        'Half Arms Wax',
        'Full Legs Wax',
        'Half Legs Wax',
        'Underarms Wax',
        'Face Wax',
        'Bikini Wax',
        'Brazilian Wax',
        'Chocolate Wax',
        'Rica Wax',
      ],
    ),
    GlowCategory(
      code: 'THREADING',
      label: 'Threading',
      icon: Icons.timeline,
      description: 'Face and brow threading',
      services: [
        'Eyebrows',
        'Upper Lip',
        'Chin',
        'Forehead',
        'Full Face',
        'Neck',
      ],
    ),
    GlowCategory(
      code: 'EYE_BROW',
      label: 'Eye & Brow',
      icon: Icons.remove_red_eye_outlined,
      description: 'Brows, lashes and tinting',
      services: [
        'Eyebrow Threading',
        'Eyebrow Shaping',
        'Eyebrow Tinting',
        'Eyelash Extensions',
        'Eyelash Lift',
        'Lash Tinting',
        'Brow Lamination',
      ],
    ),
    GlowCategory(
      code: 'BRIDAL',
      label: 'Bridal Services',
      icon: Icons.favorite_border,
      description: 'Complete bridal and couple packages',
      services: [
        'Bridal Makeup',
        'Bridal Hair Styling',
        'Bridal Facial',
        'Mehendi',
        'Saree Draping',
        'Pre-Bridal Package',
        'Bridal Spa',
        'Groom Makeup',
        'Couple Package',
      ],
    ),
    GlowCategory(
      code: 'MEHENDI',
      label: 'Mehendi',
      icon: Icons.auto_awesome,
      description: 'Bridal, Arabic and festival mehendi',
      services: [
        'Bridal Mehendi',
        'Arabic Mehendi',
        'Traditional Mehendi',
        'Indo-Arabic Mehendi',
        'Finger Mehendi',
        'Festival Mehendi',
        'Party Mehendi',
      ],
    ),
    GlowCategory(
      code: 'WELLNESS',
      label: 'Wellness',
      icon: Icons.self_improvement,
      description: 'Personal grooming and lifestyle consultation',
      services: [
        'Personal Grooming',
        'Lifestyle Consultation',
      ],
    ),
    GlowCategory(
      code: 'COSMETIC',
      label: 'Cosmetic Treatments',
      icon: Icons.medical_services_outlined,
      description: 'Advanced skin and hair clinical treatments',
      services: [
        'Laser Hair Reduction',
        'Skin Tightening',
        'Pigmentation Treatment',
        'Scar Treatment',
        'Mole Removal',
        'Wart Removal',
        'Anti-Aging Treatment',
        'PRP Hair Treatment',
        'PRP Skin Treatment',
      ],
    ),
    GlowCategory(
      code: 'PACKAGES',
      label: 'Special Packages',
      icon: Icons.card_giftcard_outlined,
      description: 'Wedding, festival and group packages',
      services: [
        'Wedding Package',
        'Birthday Package',
        'Anniversary Package',
        'Mother & Daughter Package',
        'Couple Spa',
        'Corporate Grooming',
        'Student Discount Package',
        'Festival Offer Package',
      ],
    ),
    GlowCategory(
      code: 'TRAINING',
      label: 'Training & Workshops',
      icon: Icons.school_outlined,
      description: 'Beautician courses and grooming workshops',
      services: [
        'Makeup Classes',
        'Hair Styling Classes',
        'Nail Art Training',
        'Beautician Course',
        'Skin Care Workshop',
        'Self Grooming Workshop',
      ],
    ),
  ];

  static GlowCategory? byCode(String? code) {
    if (code == null || code.isEmpty) return null;
    final key = code.trim().toUpperCase();
    for (final c in categories) {
      if (c.code == key) return c;
    }
    return _legacyMap[key];
  }

  static String labelFor(String? code) => byCode(code)?.label ?? (code ?? 'Service');

  static IconData iconFor(String? code) => byCode(code)?.icon ?? Icons.spa_outlined;

  /// Map legacy backend enum values to current categories.
  static final _legacyMap = <String, GlowCategory>{
    'FACIAL': categories.firstWhere((c) => c.code == 'SKIN_CARE'),
    'HAIRCUT': categories.firstWhere((c) => c.code == 'HAIR'),
    'HAIR_COLOR': categories.firstWhere((c) => c.code == 'HAIR'),
    'MASSAGE': categories.firstWhere((c) => c.code == 'SPA_MASSAGE'),
    'SPA': categories.firstWhere((c) => c.code == 'SPA_MASSAGE'),
    'MANICURE': categories.firstWhere((c) => c.code == 'NAIL_CARE'),
    'PEDICURE': categories.firstWhere((c) => c.code == 'NAIL_CARE'),
  };

  static int defaultDuration(String categoryCode) {
    return switch (categoryCode) {
      'SPA_MASSAGE' || 'BRIDAL' || 'PACKAGES' || 'COSMETIC' => 60,
      'MAKEUP' || 'HAIR' => 45,
      'TRAINING' => 90,
      _ => 30,
    };
  }

  static double defaultPrice(String categoryCode) {
    return switch (categoryCode) {
      'BRIDAL' || 'PACKAGES' => 2999,
      'COSMETIC' => 1999,
      'MAKEUP' => 1499,
      'SPA_MASSAGE' => 999,
      'HAIR' => 499,
      'SKIN_CARE' => 699,
      'TRAINING' => 2499,
      'MEHENDI' => 799,
      _ => 299,
    };
  }

  static const cancelPolicy =
      'Free cancellation until 2 hours before the appointment. After that the fee is not refunded.';

  static const salonTypes = [
    'Salon',
    'Spa',
    'Beauty parlour',
    'Bridal studio',
    'Nail studio',
    'Unisex salon',
    'Home service',
    'Academy',
  ];

  static const designations = [
    'Owner',
    'Manager',
    'Senior stylist',
    'Beautician',
    'Spa therapist',
    'Receptionist',
  ];

  static const audiences = [
    'Women',
    'Men',
    'Unisex',
    'Bridal',
    'Kids',
  ];

  static const facilities = [
    'AC',
    'Parking',
    'Washroom',
    'Waiting lounge',
    'Wheelchair access',
    'Sanitized tools',
    'Private cabin',
    'Card / UPI',
    'Wi-Fi',
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

  static const durations = [15, 30, 45, 60, 75, 90, 120];

  static const buffers = [0, 5, 10, 15, 20];

  static const serviceModes = ['SALON', 'DOOR', 'BOTH'];

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
