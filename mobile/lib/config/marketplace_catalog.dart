import 'package:flutter/material.dart';

/// Service Partner / provider categories aligned with backend `ProviderCategory`.
class MarketplaceCatalog {
  MarketplaceCatalog._();

  static const items = <({String code, String label, IconData icon})>[
    (code: 'TUTOR', label: 'Tutor', icon: Icons.school_outlined),
    (code: 'TAILOR', label: 'Tailor', icon: Icons.content_cut),
    (code: 'HOME_COOK', label: 'Home Cook', icon: Icons.soup_kitchen_outlined),
    (code: 'CATERING_SERVICE', label: 'Catering Service', icon: Icons.dinner_dining),
    (code: 'EVENT_PLANNER', label: 'Event Planner', icon: Icons.event_outlined),
    (code: 'BABYSITTER', label: 'Babysitter', icon: Icons.child_care_outlined),
    (code: 'PET_CARE', label: 'Pet Care', icon: Icons.pets_outlined),
    (code: 'DIETITIAN', label: 'Dietitian', icon: Icons.restaurant_outlined),
    (code: 'HOME_CLEANER', label: 'Home Cleaner', icon: Icons.cleaning_services_outlined),
    (code: 'INTERIOR_DESIGNER', label: 'Interior Designer', icon: Icons.chair_outlined),
    (code: 'HANDICRAFT_SELLER', label: 'Handicraft Seller', icon: Icons.handshake_outlined),
    (code: 'DIGITAL_MARKETING_CONSULTANT', label: 'Digital Marketing Consultant', icon: Icons.campaign_outlined),
    (code: 'HOME_BAKER', label: 'Home Baker', icon: Icons.cake_outlined),
    (code: 'LANGUAGE_TRAINER', label: 'Language Trainer', icon: Icons.translate_outlined),
    (code: 'WOMEN_PRODUCTS', label: 'Women Products', icon: Icons.shopping_bag_outlined),
    (code: 'WOMEN_LAWYER', label: 'Women Lawyer', icon: Icons.gavel_outlined),
    (code: 'FITNESS_ZUMBA', label: 'Fitness Zumba', icon: Icons.fitness_center),
    (code: 'BEAUTICIAN', label: 'Beautician', icon: Icons.spa_outlined),
    (code: 'MAKEUP_ARTIST', label: 'Makeup Artist', icon: Icons.brush_outlined),
    (code: 'MEHENDI_ARTIST', label: 'Mehendi Artist', icon: Icons.back_hand_outlined),
    (code: 'PHOTOGRAPHER', label: 'Photographer', icon: Icons.camera_alt_outlined),
    (code: 'YOGA_TRAINER', label: 'Yoga Trainer', icon: Icons.self_improvement),
    (code: 'FITNESS_TRAINER', label: 'Fitness Trainer', icon: Icons.sports_gymnastics),
    (code: 'DANCE_INSTRUCTOR', label: 'Dance Instructor', icon: Icons.music_note_outlined),
    (code: 'MUSIC_TEACHER', label: 'Music Teacher', icon: Icons.piano_outlined),
    (code: 'CRAFT_SELLER', label: 'Craft Seller', icon: Icons.palette_outlined),
    (code: 'HANDMADE_PRODUCTS', label: 'Handmade Products', icon: Icons.volunteer_activism_outlined),
    (code: 'BOUTIQUE', label: 'Boutique', icon: Icons.checkroom_outlined),
    (code: 'FASHION_DESIGNER', label: 'Fashion Designer', icon: Icons.design_services_outlined),
    (code: 'FREELANCER', label: 'Freelancer', icon: Icons.laptop_mac_outlined),
    (code: 'GRAPHIC_DESIGNER', label: 'Graphic Designer', icon: Icons.draw_outlined),
    (code: 'CONTENT_WRITER', label: 'Content Writer', icon: Icons.edit_note_outlined),
  ];

  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: 'all', label: 'All Providers', icon: Icons.grid_view_rounded),
    (value: 'TUTOR', label: 'Tutor', icon: Icons.school_outlined),
    (value: 'HOME_COOK', label: 'Cook', icon: Icons.soup_kitchen_outlined),
    (value: 'HOME_CLEANER', label: 'Cleaning', icon: Icons.cleaning_services_outlined),
    (value: 'BABYSITTER', label: 'Childcare', icon: Icons.child_care_outlined),
    (value: 'BEAUTICIAN', label: 'Beauty', icon: Icons.spa_outlined),
    (value: 'YOGA_TRAINER', label: 'Yoga', icon: Icons.self_improvement),
    (value: 'EVENT_PLANNER', label: 'Events', icon: Icons.event_outlined),
    (value: 'TAILOR', label: 'Tailor', icon: Icons.content_cut),
    (value: 'FREELANCER', label: 'Freelance', icon: Icons.laptop_mac_outlined),
  ];

  /// Service Partner Join Us — lawyers use dedicated Women Lawyer registration.
  static List<({String code, String label, IconData icon})> get servicePartnerItems =>
      items.where((e) => e.code != 'WOMEN_LAWYER').toList();

  static List<String> get labels => items.map((e) => e.label).toList();

  static List<String> get codes => items.map((e) => e.code).toList();

  static List<String> get servicePartnerCodes =>
      servicePartnerItems.map((e) => e.code).toList();

  static String labelFor(String? raw) {
    final code = codeFor(raw);
    if (code == null) return (raw ?? '').replaceAll('_', ' ');
    for (final item in items) {
      if (item.code == code) return item.label;
    }
    return code.replaceAll('_', ' ');
  }

  static String? codeFor(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final key = raw.trim().toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
    for (final item in items) {
      if (item.code == key) return item.code;
      if (item.label.toUpperCase().replaceAll(' ', '_') == key) return item.code;
    }
    return switch (key) {
      'CATERING' || 'CATERING_SERVICES' => 'CATERING_SERVICE',
      'HANDICRAFT' || 'HANDICRAFTS' => 'HANDICRAFT_SELLER',
      'DIGITAL_MARKETING' => 'DIGITAL_MARKETING_CONSULTANT',
      'HOMECOOK' || 'COOK' => 'HOME_COOK',
      'PETCARE' || 'PET_SITTER' => 'PET_CARE',
      'BABY_SITTER' || 'CHILDCARE' => 'BABYSITTER',
      'CLEANER' || 'CLEANING' => 'HOME_CLEANER',
      'INTERIOR' || 'INTERIOR_DESIGN' => 'INTERIOR_DESIGNER',
      'ZUMBA' || 'FITNESS' => 'FITNESS_ZUMBA',
      'LAWYER' => 'WOMEN_LAWYER',
      'PRODUCTS' || 'SELLER' => 'WOMEN_PRODUCTS',
      'YOGA' => 'YOGA_TRAINER',
      'DANCE' => 'DANCE_INSTRUCTOR',
      'MUSIC' => 'MUSIC_TEACHER',
      'MAKEUP' => 'MAKEUP_ARTIST',
      'MEHENDI' => 'MEHENDI_ARTIST',
      _ => key.contains('_') ? key : null,
    };
  }

  static IconData iconFor(String? raw) {
    final code = codeFor(raw) ?? '';
    for (final item in items) {
      if (item.code == code) return item.icon;
    }
    return Icons.storefront_outlined;
  }
}
