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
