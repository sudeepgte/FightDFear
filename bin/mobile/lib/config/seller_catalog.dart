import 'package:flutter/material.dart';

class SellerCategory {
  const SellerCategory({
    required this.code,
    required this.label,
    required this.icon,
    required this.emoji,
    required this.products,
    this.needsFssai = false,
    this.needsDrugLicense = false,
  });

  final String code;
  final String label;
  final IconData icon;
  final String emoji;
  final List<String> products;
  final bool needsFssai;
  final bool needsDrugLicense;
}

class SellerCatalog {
  SellerCatalog._();

  static const browseFilters = <({String value, String label, IconData icon})>[
    (value: '', label: 'All Products', icon: Icons.grid_view_rounded),
    (value: 'FASHION', label: 'Fashion', icon: Icons.checkroom_rounded),
    (value: 'BEAUTY', label: 'Beauty', icon: Icons.spa_rounded),
    (value: 'HOME_DECOR', label: 'Home Decor', icon: Icons.chair_rounded),
    (value: 'ORGANIC_FOOD', label: 'Organic', icon: Icons.eco_rounded),
    (value: 'BABY', label: 'Baby', icon: Icons.child_care_rounded),
    (value: 'JEWELLERY', label: 'Jewellery', icon: Icons.diamond_rounded),
    (value: 'BOOKS', label: 'Books', icon: Icons.menu_book_rounded),
    (value: 'FITNESS', label: 'Fitness', icon: Icons.fitness_center_rounded),
  ];

  static const cancelPolicy =
      'Free cancellation until the order is packed and assigned to a delivery partner.';

  static const designations = [
    'Shop owner',
    'Brand seller',
    'Reseller',
    'Homemaker seller',
    'Other',
  ];

  static const audiences = [
    'Women',
    'Families',
    'Working professionals',
    'Students',
    'Kids',
  ];

  static const facilities = [
    'Packed ready',
    'Returns accepted',
    'COD available',
    'UPI / card',
    'Gift wrap',
    'Same-day dispatch',
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

  static const dispatchHours = [6, 12, 24, 48, 72];

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

  static const themes = ['Modern', 'Elegant', 'Minimal', 'Traditional', 'Luxury'];

  static const brandTypes = ['Own Brand', 'Reseller'];

  static const weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const categories = <SellerCategory>[
    SellerCategory(
      code: 'FASHION',
      label: 'Fashion',
      emoji: '👜',
      icon: Icons.checkroom_rounded,
      products: [
        'Sarees',
        'Kurtis',
        'Dresses',
        'Leggings',
        'Tops',
        'Jeans',
        'Ethnic Wear',
        'Accessories',
      ],
    ),
    SellerCategory(
      code: 'BEAUTY',
      label: 'Beauty',
      emoji: '💄',
      icon: Icons.spa_rounded,
      products: [
        'Lipstick',
        'Face Wash',
        'Sunscreen',
        'Hair Oil',
        'Shampoo',
        'Perfume',
        'Kajal',
        'Moisturizer',
      ],
      needsDrugLicense: true,
    ),
    SellerCategory(
      code: 'HOME_DECOR',
      label: 'Home Decor',
      emoji: '🏠',
      icon: Icons.chair_rounded,
      products: [
        'Wall Art',
        'Cushions',
        'Lamps',
        'Vases',
        'Rugs',
        'Planters',
        'Candles',
        'Frames',
      ],
    ),
    SellerCategory(
      code: 'ORGANIC_FOOD',
      label: 'Organic Food',
      emoji: '🍎',
      icon: Icons.eco_rounded,
      products: [
        'Spices',
        'Millets',
        'Snacks',
        'Honey',
        'Oils',
        'Tea',
        'Pickles',
        'Dry Fruits',
      ],
      needsFssai: true,
    ),
    SellerCategory(
      code: 'BABY',
      label: 'Baby Products',
      emoji: '🍼',
      icon: Icons.child_care_rounded,
      products: [
        'Clothes',
        'Toys',
        'Diapers',
        'Feeding',
        'Skincare',
        'Blankets',
        'Bottles',
        'Accessories',
      ],
    ),
    SellerCategory(
      code: 'JEWELLERY',
      label: 'Jewellery',
      emoji: '💍',
      icon: Icons.diamond_rounded,
      products: [
        'Earrings',
        'Necklaces',
        'Bangles',
        'Rings',
        'Anklets',
        'Sets',
        'Hair Pins',
        'Bracelets',
      ],
    ),
    SellerCategory(
      code: 'BOOKS',
      label: 'Books',
      emoji: '📚',
      icon: Icons.menu_book_rounded,
      products: [
        'Fiction',
        'Non-Fiction',
        'Children',
        'Self-Help',
        'Cookbooks',
        'Stationery',
        'Comics',
        'Academic',
      ],
    ),
    SellerCategory(
      code: 'FITNESS',
      label: 'Fitness',
      emoji: '🧘',
      icon: Icons.fitness_center_rounded,
      products: [
        'Yoga Mats',
        'Activewear',
        'Equipment',
        'Supplements',
        'Water Bottles',
        'Resistance Bands',
        'Bags',
        'Accessories',
      ],
      needsDrugLicense: true,
    ),
  ];

  static SellerCategory? byCode(String code) {
    for (final c in categories) {
      if (c.code == code) return c;
    }
    return null;
  }

  static String labelFor(String code) => byCode(code)?.label ?? code;

  static bool needsFssai(Iterable<String> codes) =>
      codes.any((c) => byCode(c)?.needsFssai == true);

  static bool needsDrugLicense(Iterable<String> codes) =>
      codes.any((c) => byCode(c)?.needsDrugLicense == true);

  static List<String> productsFor(Iterable<String> codes) {
    final out = <String>[];
    final seen = <String>{};
    for (final code in codes) {
      final cat = byCode(code);
      if (cat == null) continue;
      for (final p in cat.products) {
        if (seen.add(p)) out.add(p);
      }
    }
    return out;
  }
}
