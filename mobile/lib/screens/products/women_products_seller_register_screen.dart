import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'women_products_seller_login_screen.dart';

class WomenProductsSellerRegisterScreen extends StatefulWidget {
  const WomenProductsSellerRegisterScreen({super.key});

  @override
  State<WomenProductsSellerRegisterScreen> createState() =>
      _WomenProductsSellerRegisterScreenState();
}

class _WomenProductsSellerRegisterScreenState
    extends State<WomenProductsSellerRegisterScreen> {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color softBg = Color(0xFFFFF1F5);
  static const Color muted = Color(0xFF64748B);
  static const _draftKey = 'product_seller_register_draft_v1';

  static const _steps = [
    'Categories',
    'Shop',
    'Location',
    'Verify',
    'Bank & Ship',
    'Products',
    'Media',
    'Account',
  ];

  final _page = PageController();
  int _step = 0;
  bool _busy = false;
  bool _locating = false;
  String? _error;

  // Account
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;

  // Shop / brand
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _businessName = TextEditingController();
  final _brandName = TextEditingController();
  final _yearStarted = TextEditingController();
  final _productCount = TextEditingController();
  final _description = TextEditingController();
  String _brandType = SellerCatalog.brandTypes.first;

  // Categories
  final Set<String> _categories = {};
  final Set<String> _subProducts = {};
  String? _expandedCategory;

  // Location
  final _address = TextEditingController();
  final _city = TextEditingController();
  double? _lat;
  double? _lng;

  // Hours: day -> {start, end, closed}
  late final Map<String, _DayHours> _hours;

  // Verification
  final _gst = TextEditingController();
  final _pan = TextEditingController();
  final _aadhaar = TextEditingController();
  final _msme = TextEditingController();
  final _fssai = TextEditingController();
  final _drugLicense = TextEditingController();
  final _trademark = TextEditingController();

  // Bank
  final _accountHolder = TextEditingController();
  final _bankName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _upi = TextEditingController();

  // Shipping
  final _shippingRadius = TextEditingController(text: '10');
  final _deliveryCharges = TextEditingController(text: '40');
  final _freeAbove = TextEditingController(text: '499');
  final _deliveryTime = TextEditingController(text: '2–4 days');
  bool _cod = true;
  bool _returns = true;
  final Set<String> _deliveryModes = {'Local Delivery'};

  // Sample products
  late final List<_SampleProduct> _samples;

  // Media / theme / social
  String? _logoName;
  String? _bannerName;
  String _theme = SellerCatalog.themes.first;
  final _instagram = TextEditingController();
  final _facebook = TextEditingController();
  final _website = TextEditingController();
  final _whatsapp = TextEditingController();
  final _telegram = TextEditingController();
  final _youtube = TextEditingController();
  final _pinterest = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hours = {
      for (final d in SellerCatalog.weekDays)
        d: _DayHours(
          start: TextEditingController(text: d == 'Sunday' ? '' : '09:00'),
          end: TextEditingController(text: d == 'Sunday' ? '' : '18:00'),
          closed: d == 'Sunday',
        ),
    };
    _samples = List.generate(3, (_) => _SampleProduct());
    _loadDraft();
  }

  @override
  void dispose() {
    _page.dispose();
    for (final c in [
      _email, _password, _confirm, _fullName, _phone, _businessName, _brandName,
      _yearStarted, _productCount, _description, _address, _city, _gst, _pan,
      _aadhaar, _msme, _fssai, _drugLicense, _trademark, _accountHolder, _bankName,
      _accountNumber, _ifsc, _upi, _shippingRadius, _deliveryCharges, _freeAbove,
      _deliveryTime, _instagram, _facebook, _website, _whatsapp, _telegram,
      _youtube, _pinterest,
    ]) {
      c.dispose();
    }
    for (final h in _hours.values) {
      h.start.dispose();
      h.end.dispose();
    }
    for (final s in _samples) {
      s.name.dispose();
      s.price.dispose();
      s.stock.dispose();
    }
    super.dispose();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        _email.text = m['email']?.toString() ?? '';
        _fullName.text = m['fullName']?.toString() ?? '';
        _phone.text = m['phone']?.toString() ?? '';
        _businessName.text = m['businessName']?.toString() ?? '';
        _brandName.text = m['brandName']?.toString() ?? '';
        _brandType = m['brandType']?.toString() ?? _brandType;
        _yearStarted.text = m['yearStarted']?.toString() ?? '';
        _productCount.text = m['productCount']?.toString() ?? '';
        _description.text = m['description']?.toString() ?? '';
        _address.text = m['address']?.toString() ?? '';
        _city.text = m['city']?.toString() ?? '';
        _lat = (m['lat'] as num?)?.toDouble();
        _lng = (m['lng'] as num?)?.toDouble();
        _gst.text = m['gst']?.toString() ?? '';
        _pan.text = m['pan']?.toString() ?? '';
        _aadhaar.text = m['aadhaar']?.toString() ?? '';
        _msme.text = m['msme']?.toString() ?? '';
        _fssai.text = m['fssai']?.toString() ?? '';
        _drugLicense.text = m['drugLicense']?.toString() ?? '';
        _trademark.text = m['trademark']?.toString() ?? '';
        _accountHolder.text = m['accountHolder']?.toString() ?? '';
        _bankName.text = m['bankName']?.toString() ?? '';
        _accountNumber.text = m['accountNumber']?.toString() ?? '';
        _ifsc.text = m['ifsc']?.toString() ?? '';
        _upi.text = m['upi']?.toString() ?? '';
        _shippingRadius.text = m['shippingRadius']?.toString() ?? _shippingRadius.text;
        _deliveryCharges.text = m['deliveryCharges']?.toString() ?? _deliveryCharges.text;
        _freeAbove.text = m['freeAbove']?.toString() ?? _freeAbove.text;
        _deliveryTime.text = m['deliveryTime']?.toString() ?? _deliveryTime.text;
        _cod = m['cod'] == true;
        _returns = m['returns'] != false;
        _theme = m['theme']?.toString() ?? _theme;
        _instagram.text = m['instagram']?.toString() ?? '';
        _facebook.text = m['facebook']?.toString() ?? '';
        _website.text = m['website']?.toString() ?? '';
        _whatsapp.text = m['whatsapp']?.toString() ?? '';
        _telegram.text = m['telegram']?.toString() ?? '';
        _youtube.text = m['youtube']?.toString() ?? '';
        _pinterest.text = m['pinterest']?.toString() ?? '';
        _logoName = m['logoName']?.toString();
        _bannerName = m['bannerName']?.toString();
        _categories
          ..clear()
          ..addAll(((m['categories'] as List?) ?? []).map((e) => e.toString()));
        _subProducts
          ..clear()
          ..addAll(((m['subProducts'] as List?) ?? []).map((e) => e.toString()));
        _deliveryModes
          ..clear()
          ..addAll(((m['deliveryModes'] as List?) ?? ['Local Delivery']).map((e) => e.toString()));
        final hours = m['hours'] as Map<String, dynamic>? ?? {};
        for (final e in hours.entries) {
          final day = _hours[e.key];
          if (day == null) continue;
          final h = e.value as Map<String, dynamic>;
          day.closed = h['closed'] == true;
          day.start.text = h['start']?.toString() ?? '';
          day.end.text = h['end']?.toString() ?? '';
        }
        final samples = (m['samples'] as List?) ?? [];
        for (var i = 0; i < _samples.length && i < samples.length; i++) {
          final s = samples[i] as Map<String, dynamic>;
          _samples[i].name.text = s['name']?.toString() ?? '';
          _samples[i].category = s['category']?.toString() ?? '';
          _samples[i].price.text = s['price']?.toString() ?? '';
          _samples[i].stock.text = s['stock']?.toString() ?? '';
          _samples[i].imageName = s['imageName']?.toString();
        }
        _step = (m['step'] as num?)?.toInt().clamp(0, _steps.length - 1) ?? 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_page.hasClients) _page.jumpToPage(_step);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft restored — continue where you left off')),
        );
      }
    } catch (_) {}
  }

  Future<void> _saveDraft({bool notify = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'step': _step,
      'email': _email.text,
      'fullName': _fullName.text,
      'phone': _phone.text,
      'businessName': _businessName.text,
      'brandName': _brandName.text,
      'brandType': _brandType,
      'yearStarted': _yearStarted.text,
      'productCount': _productCount.text,
      'description': _description.text,
      'address': _address.text,
      'city': _city.text,
      'lat': _lat,
      'lng': _lng,
      'gst': _gst.text,
      'pan': _pan.text,
      'aadhaar': _aadhaar.text,
      'msme': _msme.text,
      'fssai': _fssai.text,
      'drugLicense': _drugLicense.text,
      'trademark': _trademark.text,
      'accountHolder': _accountHolder.text,
      'bankName': _bankName.text,
      'accountNumber': _accountNumber.text,
      'ifsc': _ifsc.text,
      'upi': _upi.text,
      'shippingRadius': _shippingRadius.text,
      'deliveryCharges': _deliveryCharges.text,
      'freeAbove': _freeAbove.text,
      'deliveryTime': _deliveryTime.text,
      'cod': _cod,
      'returns': _returns,
      'theme': _theme,
      'instagram': _instagram.text,
      'facebook': _facebook.text,
      'website': _website.text,
      'whatsapp': _whatsapp.text,
      'telegram': _telegram.text,
      'youtube': _youtube.text,
      'pinterest': _pinterest.text,
      'logoName': _logoName,
      'bannerName': _bannerName,
      'categories': _categories.toList(),
      'subProducts': _subProducts.toList(),
      'deliveryModes': _deliveryModes.toList(),
      'hours': {
        for (final e in _hours.entries)
          e.key: {
            'closed': e.value.closed,
            'start': e.value.start.text,
            'end': e.value.end.text,
          },
      },
      'samples': [
        for (final s in _samples)
          {
            'name': s.name.text,
            'category': s.category,
            'price': s.price.text,
            'stock': s.stock.text,
            'imageName': s.imageName,
          },
      ],
    };
    await prefs.setString(_draftKey, jsonEncode(payload));
    if (notify && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved — you can continue later')),
      );
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  // —— completion ——
  List<_CheckItem> get _completionItems {
    return [
      _CheckItem('Shop details', _businessName.text.trim().isNotEmpty && _fullName.text.trim().isNotEmpty),
      _CheckItem('Categories', _categories.isNotEmpty && _subProducts.isNotEmpty),
      _CheckItem('Address', _address.text.trim().isNotEmpty && _city.text.trim().isNotEmpty),
      _CheckItem('Email', RegValidators.isEmail(_email.text)),
      _CheckItem('Logo', _logoName != null && _logoName!.isNotEmpty, warnIfMissing: true),
      _CheckItem('Banner', _bannerName != null && _bannerName!.isNotEmpty, warnIfMissing: true),
      _CheckItem('Bank details', _accountHolder.text.trim().isNotEmpty && _ifsc.text.trim().isNotEmpty),
      _CheckItem('Sample products', _samples.any((s) => s.name.text.trim().isNotEmpty)),
    ];
  }

  double get _completionPct {
    final items = _completionItems;
    if (items.isEmpty) return 0;
    final done = items.where((e) => e.ok).length;
    return done / items.length;
  }

  bool get _passLen => _password.text.length >= 8;
  bool get _passUpper => RegExp(r'[A-Z]').hasMatch(_password.text);
  bool get _passLower => RegExp(r'[a-z]').hasMatch(_password.text);
  bool get _passNum => RegExp(r'[0-9]').hasMatch(_password.text);
  bool get _passSpecial => RegExp(r'[!@#$%^&*]').hasMatch(_password.text);
  bool get _passwordOk => _passLen && _passUpper && _passLower && _passNum && _passSpecial;

  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_categories.isEmpty) return 'Select at least one product category';
        if (_subProducts.isEmpty) return 'Select product types under your category';
        return null;
      case 1:
        if (_fullName.text.trim().isEmpty) return 'Full name is required';
        if (!RegValidators.isPhone10(_phone.text)) return 'Phone must be exactly 10 digits';
        if (_businessName.text.trim().isEmpty) return 'Business / shop name is required';
        if (_description.text.trim().isEmpty) return 'Business description is required';
        return null;
      case 2:
        if (_address.text.trim().isEmpty) return 'Shop address is required';
        if (_city.text.trim().isEmpty) return 'City is required';
        final openDays = _hours.values.where((h) => !h.closed);
        if (openDays.isEmpty) return 'Keep at least one working day open';
        return null;
      case 3:
        if (_pan.text.trim().isEmpty) return 'PAN is required';
        if (_aadhaar.text.trim().isEmpty) return 'Aadhaar is required';
        if (SellerCatalog.needsFssai(_categories) && _fssai.text.trim().isEmpty) {
          return 'FSSAI license is required for Organic Food';
        }
        if (SellerCatalog.needsDrugLicense(_categories) && _drugLicense.text.trim().isEmpty) {
          return 'Drug license is required for Beauty / Fitness products';
        }
        return null;
      case 4:
        if (_accountHolder.text.trim().isEmpty) return 'Account holder name is required';
        if (_bankName.text.trim().isEmpty) return 'Bank name is required';
        if (_accountNumber.text.trim().isEmpty) return 'Account number is required';
        if (_ifsc.text.trim().isEmpty) return 'IFSC is required';
        if (_deliveryModes.isEmpty) return 'Select at least one delivery option';
        return null;
      case 5:
        final filled = _samples.where((s) => s.name.text.trim().isNotEmpty).length;
        if (filled < 1) return 'Add at least 1 sample product for admin review';
        return null;
      case 6:
        return null;
      case 7:
        final e = RegValidators.emailError(_email.text);
        if (e != null) return e;
        if (!_passwordOk) return 'Password must meet all strength checks';
        if (_password.text != _confirm.text) return 'Passwords do not match';
        if (!_terms) return 'Please accept Terms & Conditions';
        return null;
      default:
        return null;
    }
  }

  Future<void> _next() async {
    final err = _validateStep(_step);
    if (err != null) {
      setState(() => _error = err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    setState(() => _error = null);
    await _saveDraft(notify: false);
    if (_step >= _steps.length - 1) {
      await _showPreviewAndSubmit();
      return;
    }
    setState(() => _step++);
    await _page.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  Future<void> _back() async {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _step--;
      _error = null;
    });
    await _page.previousPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        if (_address.text.trim().isEmpty) {
          _address.text =
              'Lat ${pos.latitude.toStringAsFixed(5)}, Lng ${pos.longitude.toStringAsFixed(5)}';
        } else if (!_address.text.contains('Lat ')) {
          _address.text =
              '${_address.text.trim()}\nLat ${pos.latitude.toStringAsFixed(5)}, Lng ${pos.longitude.toStringAsFixed(5)}';
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current location added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickFile(void Function(String name) onPicked) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final name = result.files.first.name;
    setState(() => onPicked(name));
  }

  Map<String, String> _buildPayload() {
    final categoryLabels = _categories.map(SellerCatalog.labelFor).join(', ');
    final hoursLines = _hours.entries.map((e) {
      if (e.value.closed) return '${e.key}: Closed';
      return '${e.key}: ${e.value.start.text}–${e.value.end.text}';
    }).join('\n');
    final samples = _samples
        .where((s) => s.name.text.trim().isNotEmpty)
        .map((s) =>
            '${s.name.text.trim()} | ${s.category} | ₹${s.price.text.trim()} | stock ${s.stock.text.trim()}${s.imageName != null ? ' | img:${s.imageName}' : ''}')
        .join('\n');

    final description = [
      _description.text.trim(),
      'Categories: $categoryLabels',
      if (_subProducts.isNotEmpty) 'Products: ${_subProducts.join(', ')}',
      'Brand: ${_brandName.text.trim().isEmpty ? _businessName.text.trim() : _brandName.text.trim()} ($_brandType)',
      if (_yearStarted.text.trim().isNotEmpty) 'Year started: ${_yearStarted.text.trim()}',
      if (_productCount.text.trim().isNotEmpty) 'Products listed: ${_productCount.text.trim()}',
      'Theme: $_theme',
      'Hours:\n$hoursLines',
      'Delivery: ${_deliveryModes.join(', ')}',
      'Shipping radius: ${_shippingRadius.text.trim()} km',
      'Delivery charges: ₹${_deliveryCharges.text.trim()}',
      'Free delivery above: ₹${_freeAbove.text.trim()}',
      'Delivery time: ${_deliveryTime.text.trim()}',
      'COD: ${_cod ? 'Yes' : 'No'}',
      'Returns: ${_returns ? 'Yes' : 'No'}',
      if (_gst.text.trim().isNotEmpty) 'GST: ${_gst.text.trim()}',
      'PAN: ${_pan.text.trim()}',
      'Aadhaar: ${_aadhaar.text.trim()}',
      if (_msme.text.trim().isNotEmpty) 'MSME/UDYAM: ${_msme.text.trim()}',
      if (_fssai.text.trim().isNotEmpty) 'FSSAI: ${_fssai.text.trim()}',
      if (_drugLicense.text.trim().isNotEmpty) 'Drug License: ${_drugLicense.text.trim()}',
      if (_trademark.text.trim().isNotEmpty) 'Trademark: ${_trademark.text.trim()}',
      'Bank: ${_accountHolder.text.trim()} / ${_bankName.text.trim()} / A/C ${_accountNumber.text.trim()} / IFSC ${_ifsc.text.trim()}',
      if (_upi.text.trim().isNotEmpty) 'UPI: ${_upi.text.trim()}',
      if (_whatsapp.text.trim().isNotEmpty) 'WhatsApp: ${_whatsapp.text.trim()}',
      if (_telegram.text.trim().isNotEmpty) 'Telegram: ${_telegram.text.trim()}',
      if (_instagram.text.trim().isNotEmpty) 'IG: ${_instagram.text.trim()}',
      if (_facebook.text.trim().isNotEmpty) 'FB: ${_facebook.text.trim()}',
      if (_youtube.text.trim().isNotEmpty) 'YT: ${_youtube.text.trim()}',
      if (_pinterest.text.trim().isNotEmpty) 'Pinterest: ${_pinterest.text.trim()}',
      if (_website.text.trim().isNotEmpty) 'Web: ${_website.text.trim()}',
      if (samples.isNotEmpty) 'Sample products:\n$samples',
      if (_bannerName != null) 'Banner: mobile:$_bannerName',
    ].where((e) => e.trim().isNotEmpty).join('\n');

    final address = [
      _address.text.trim(),
      if (_city.text.trim().isNotEmpty) 'City: ${_city.text.trim()}',
      if (_lat != null && _lng != null)
        'Maps: ${_lat!.toStringAsFixed(5)},${_lng!.toStringAsFixed(5)}',
    ].join('\n');

    return {
      'fullName': _fullName.text.trim(),
      'businessName': _businessName.text.trim(),
      'email': _email.text.trim().toLowerCase(),
      'phone': _phone.text.trim(),
      'address': address,
      'description': description,
      'password': _password.text,
      'confirmPassword': _confirm.text,
      'logoPath': _logoName == null || _logoName!.isEmpty ? 'mobile-pending' : 'mobile:$_logoName',
      'bannerPath':
          _bannerName == null || _bannerName!.isEmpty ? 'mobile-pending' : 'mobile:$_bannerName',
    };
  }

  Future<void> _showPreviewAndSubmit() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scroll) {
            return ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Live shop preview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: navy)),
                const SizedBox(height: 4),
                const Text('Exactly as customers will see it', style: TextStyle(color: muted)),
                const SizedBox(height: 16),
                _ShopPreviewCard(
                  businessName: _businessName.text.trim(),
                  description: _description.text.trim(),
                  categories: _categories.map(SellerCatalog.labelFor).toList(),
                  subProducts: _subProducts.toList(),
                  theme: _theme,
                  logoName: _logoName,
                  bannerName: _bannerName,
                  hours: _hours,
                  deliveryModes: _deliveryModes.toList(),
                  city: _city.text.trim(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Submit for verification'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Go back and edit'),
                ),
              ],
            );
          },
        );
      },
    );
    if (confirmed != true || !mounted) return;
    await _submit();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final api = WomenProductsSellerAuthService(context.read<AuthState>().api);
    final res = await api.register(_buildPayload());
    if (!mounted) return;
    setState(() => _busy = false);
    final ok = res['success'] == true;
    if (ok) {
      await _clearDraft();
      if (!mounted) return;
      await showRegistrationSuccessDialog(
        context,
        message: res['message']?.toString() ??
            'Product Seller registration submitted. Your shop is under verification and will activate after admin approval.',
        onDone: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen()),
          );
        },
      );
    } else {
      final err = res['error']?.toString() ?? res['message']?.toString() ?? 'Registration failed';
      setState(() => _error = err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      appBar: AppBar(
        backgroundColor: softBg,
        elevation: 0,
        foregroundColor: navy,
        title: const Text('Product Seller Join', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => _saveDraft(),
            child: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
        children: [
          _header(),
          _progress(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          Expanded(
            child: PageView(
              controller: _page,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _stepCategories(),
                _stepShop(),
                _stepLocation(),
                _stepVerify(),
                _stepBankShip(),
                _stepProducts(),
                _stepMedia(),
                _stepAccount(),
              ],
            ),
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Join as Product Seller',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: navy, height: 1.15)),
          const SizedBox(height: 4),
          const Text('Complete your shop profile. Account activates after admin verification.',
              style: TextStyle(color: muted, fontSize: 13)),
          const SizedBox(height: 12),
          _completionCard(),
        ],
      ),
    );
  }

  Widget _completionCard() {
    final pct = (_completionPct * 100).round();
    final items = _completionItems;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBCFE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Profile Completion',
                    style: TextStyle(fontWeight: FontWeight.w800, color: navy)),
              ),
              Text('$pct%', style: const TextStyle(fontWeight: FontWeight.w800, color: primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _completionPct,
              minHeight: 8,
              backgroundColor: const Color(0xFFFCE7F3),
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final i in items)
                _chipStatus(
                  i.label,
                  ok: i.ok,
                  warn: !i.ok && i.warnIfMissing,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipStatus(String label, {required bool ok, bool warn = false}) {
    final color = ok ? const Color(0xFF15803D) : (warn ? const Color(0xFFB45309) : muted);
    final icon = ok ? Icons.check_circle : (warn ? Icons.warning_amber_rounded : Icons.radio_button_unchecked);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= _step ? primary : const Color(0xFFFBCFE8),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: i == _step ? primary : muted,
                    ),
                  ),
                ],
              ),
            ),
            if (i < _steps.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _busy ? null : _back,
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(color: Color(0xFFF9A8D4)),
                minimumSize: const Size(96, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_step == 0 ? 'Close' : 'Back'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: _busy ? null : _next,
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_step == _steps.length - 1 ? 'Preview & Submit' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // —— steps ——

  Widget _stepCategories() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Choose your categories'),
        const Text('Tap a card, then pick the products you sell.', style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: SellerCatalog.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (_, i) {
            final cat = SellerCatalog.categories[i];
            final selected = _categories.contains(cat.code);
            return InkWell(
              onTap: () {
                setState(() {
                  if (selected) {
                    _categories.remove(cat.code);
                    _subProducts.removeWhere(cat.products.contains);
                    if (_expandedCategory == cat.code) _expandedCategory = null;
                  } else {
                    _categories.add(cat.code);
                    _expandedCategory = cat.code;
                  }
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFFFE4E6) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? primary : const Color(0xFFFCE7F3),
                    width: selected ? 1.6 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                        const Spacer(),
                        if (selected) const Icon(Icons.check_circle, color: primary, size: 18),
                      ],
                    ),
                    const Spacer(),
                    Text(cat.label,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: navy, fontSize: 15)),
                    Text('${cat.products.length} product types',
                        style: const TextStyle(fontSize: 11, color: muted)),
                  ],
                ),
              ),
            );
          },
        ),
        if (_categories.isNotEmpty) ...[
          const SizedBox(height: 18),
          _sectionTitle('Product types'),
          for (final code in _categories) ...[
            Builder(builder: (_) {
              final cat = SellerCatalog.byCode(code)!;
              final open = _expandedCategory == code;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFCE7F3)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${cat.emoji} ${cat.label}',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                      trailing: Icon(open ? Icons.expand_less : Icons.expand_more),
                      onTap: () => setState(() => _expandedCategory = open ? null : code),
                    ),
                    if (open)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final p in cat.products)
                              FilterChip(
                                label: Text(p),
                                selected: _subProducts.contains(p),
                                onSelected: (v) => setState(() {
                                  if (v) {
                                    _subProducts.add(p);
                                  } else {
                                    _subProducts.remove(p);
                                  }
                                }),
                                selectedColor: const Color(0xFFFFE4E6),
                                checkmarkColor: primary,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _subProducts.contains(p) ? primary : navy,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ],
      ],
    );
  }

  Widget _stepShop() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Shop & brand'),
        _field(_fullName, 'Full name *'),
        _field(_phone, 'Phone *', keyboard: TextInputType.phone, digitsOnly: true, maxLength: 10),
        _field(_businessName, 'Business / shop name *'),
        _field(_brandName, 'Brand name'),
        const SizedBox(height: 4),
        const Text('Own Brand / Reseller', style: TextStyle(fontWeight: FontWeight.w700, color: navy)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final t in SellerCatalog.brandTypes)
              ChoiceChip(
                label: Text(t),
                selected: _brandType == t,
                onSelected: (_) => setState(() => _brandType = t),
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _brandType == t ? primary : navy,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _field(_yearStarted, 'Year started', keyboard: TextInputType.number, digitsOnly: true, maxLength: 4)),
            const SizedBox(width: 10),
            Expanded(child: _field(_productCount, 'No. of products', keyboard: TextInputType.number, digitsOnly: true)),
          ],
        ),
        _field(_description, 'Business description *', maxLines: 4, maxLength: 400),
        const SizedBox(height: 8),
        _benefitsCard(),
      ],
    );
  }

  Widget _stepLocation() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Address & maps'),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _locating ? null : _useCurrentLocation,
                icon: _locating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
                style: OutlinedButton.styleFrom(foregroundColor: primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _field(_address, 'Shop address / Maps location *', maxLines: 3,
            hint: 'Search or paste address / Maps pin'),
        _field(_city, 'City *'),
        if (_lat != null && _lng != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '📍 ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
              style: const TextStyle(color: muted, fontWeight: FontWeight.w600),
            ),
          ),
        _sectionTitle('Working hours'),
        for (final day in SellerCatalog.weekDays) _dayHoursRow(day, _hours[day]!),
      ],
    );
  }

  Widget _dayHoursRow(String day, _DayHours h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCE7F3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(day, style: const TextStyle(fontWeight: FontWeight.w700, color: navy)),
          ),
          Switch(
            value: !h.closed,
            activeThumbColor: primary,
            onChanged: (open) => setState(() {
              h.closed = !open;
              if (open && h.start.text.isEmpty) {
                h.start.text = '09:00';
                h.end.text = '18:00';
              }
            }),
          ),
          if (h.closed)
            const Expanded(child: Text('Closed', style: TextStyle(color: muted, fontWeight: FontWeight.w600)))
          else ...[
            Expanded(child: _miniTime(h.start, 'Open')),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('–')),
            Expanded(child: _miniTime(h.end, 'Close')),
          ],
        ],
      ),
    );
  }

  Widget _miniTime(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }

  Widget _stepVerify() {
    final fssai = SellerCatalog.needsFssai(_categories);
    final drug = SellerCatalog.needsDrugLicense(_categories);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Business verification'),
        const Text('Relevant licenses appear based on your categories.', style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        _field(_gst, 'GST (optional)'),
        _field(_pan, 'PAN *'),
        _field(_aadhaar, 'Aadhaar *', keyboard: TextInputType.number, digitsOnly: true, maxLength: 12),
        _field(_msme, 'MSME / UDYAM (optional)'),
        if (fssai) _field(_fssai, 'FSSAI (Food) *'),
        if (drug) _field(_drugLicense, 'Drug License (Medical) *'),
        _field(_trademark, 'Trademark (optional)'),
      ],
    );
  }

  Widget _stepBankShip() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Bank details'),
        _field(_accountHolder, 'Account holder name *'),
        _field(_bankName, 'Bank name *'),
        _field(_accountNumber, 'Account number *', keyboard: TextInputType.number, digitsOnly: true),
        _field(_ifsc, 'IFSC *'),
        _field(_upi, 'UPI ID'),
        const SizedBox(height: 8),
        _sectionTitle('Shipping settings'),
        const Text('Delivery options', style: TextStyle(fontWeight: FontWeight.w700, color: navy)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final o in const ['Pickup', 'Local Delivery', 'Courier'])
              FilterChip(
                label: Text(o),
                selected: _deliveryModes.contains(o),
                onSelected: (v) => setState(() {
                  if (v) {
                    _deliveryModes.add(o);
                  } else {
                    _deliveryModes.remove(o);
                  }
                }),
                selectedColor: const Color(0xFFFFE4E6),
                checkmarkColor: primary,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _field(_shippingRadius, 'Shipping radius (km)', keyboard: TextInputType.number),
        _field(_deliveryCharges, 'Delivery charges (₹)', keyboard: TextInputType.number),
        _field(_freeAbove, 'Free delivery above ₹', keyboard: TextInputType.number),
        _field(_deliveryTime, 'Delivery time', hint: 'e.g. 2–4 days'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.w700)),
          value: _cod,
          activeThumbColor: primary,
          onChanged: (v) => setState(() => _cod = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Return available', style: TextStyle(fontWeight: FontWeight.w700)),
          value: _returns,
          activeThumbColor: primary,
          onChanged: (v) => setState(() => _returns = v),
        ),
      ],
    );
  }

  Widget _stepProducts() {
    final cats = SellerCatalog.productsFor(_categories);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Sample products'),
        const Text('Add up to 3 products so admins can verify your shop.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        for (var i = 0; i < _samples.length; i++) ...[
          _sampleCard(i, cats),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _sampleCard(int index, List<String> cats) {
    final s = _samples[index];
    final options = cats.isNotEmpty ? cats : const ['General'];
    if (s.category.isEmpty || !options.contains(s.category)) {
      s.category = options.first;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCE7F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
          const SizedBox(height: 8),
          _uploadCard(
            title: s.imageName == null ? 'Product image' : 'Image uploaded',
            fileName: s.imageName,
            onPick: () => _pickFile((n) => setState(() => s.imageName = n)),
            onClear: s.imageName == null ? null : () => setState(() => s.imageName = null),
          ),
          const SizedBox(height: 8),
          _field(s.name, 'Name'),
          DropdownButtonFormField<String>(
            initialValue: s.category,
            decoration: _decoration('Category'),
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => s.category = v ?? s.category),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _field(s.price, 'Price ₹', keyboard: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(child: _field(s.stock, 'Stock', keyboard: TextInputType.number, digitsOnly: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepMedia() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Shop media'),
        _uploadCard(
          title: _logoName == null ? 'Upload logo' : 'Logo uploaded',
          fileName: _logoName,
          onPick: () => _pickFile((n) => setState(() => _logoName = n)),
          onClear: _logoName == null ? null : () => setState(() => _logoName = null),
        ),
        const SizedBox(height: 10),
        _uploadCard(
          title: _bannerName == null ? 'Upload banner / cover' : 'Banner uploaded',
          fileName: _bannerName,
          onPick: () => _pickFile((n) => setState(() => _bannerName = n)),
          onClear: _bannerName == null ? null : () => setState(() => _bannerName = null),
        ),
        const SizedBox(height: 16),
        _sectionTitle('Shop theme'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in SellerCatalog.themes)
              ChoiceChip(
                label: Text(t),
                selected: _theme == t,
                onSelected: (_) => setState(() => _theme = t),
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _theme == t ? primary : navy,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _sectionTitle('Social & messaging'),
        _field(_whatsapp, 'WhatsApp Business', keyboard: TextInputType.phone),
        _field(_telegram, 'Telegram'),
        _field(_instagram, 'Instagram'),
        _field(_facebook, 'Facebook'),
        _field(_youtube, 'YouTube'),
        _field(_pinterest, 'Pinterest'),
        _field(_website, 'Website'),
      ],
    );
  }

  Widget _stepAccount() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Create account'),
        _field(_email, 'Email *', keyboard: TextInputType.emailAddress),
        _field(_password, 'Password *', obscure: true, onChanged: (_) => setState(() {})),
        const SizedBox(height: 4),
        _passCheck('8 Characters', _passLen),
        _passCheck('Uppercase', _passUpper),
        _passCheck('Lowercase', _passLower),
        _passCheck('Number', _passNum),
        _passCheck('Special Character', _passSpecial),
        const SizedBox(height: 8),
        _field(_confirm, 'Confirm password *', obscure: true),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _terms,
          activeColor: primary,
          onChanged: (v) => setState(() => _terms = v ?? false),
          title: const Text('I accept Terms & Conditions',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 8),
        _benefitsCard(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _saveDraft(),
          icon: const Icon(Icons.bookmark_outline),
          label: const Text('Save Draft · Continue Later'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _passCheck(String label, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16, color: ok ? const Color(0xFF15803D) : muted),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ok ? const Color(0xFF15803D) : muted,
              )),
        ],
      ),
    );
  }

  Widget _benefitsCard() {
    const benefits = [
      'Verified Seller Badge',
      'Secure Payments',
      'Product Promotion',
      'Analytics Dashboard',
      'Customer Reviews',
      'Wallet',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCE7F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Seller benefits', style: TextStyle(fontWeight: FontWeight.w800, color: navy)),
          const SizedBox(height: 8),
          for (final b in benefits)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: primary, size: 18),
                  const SizedBox(width: 8),
                  Text(b, style: const TextStyle(fontWeight: FontWeight.w600, color: navy)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _uploadCard({
    required String title,
    required String? fileName,
    required VoidCallback onPick,
    VoidCallback? onClear,
  }) {
    final uploaded = fileName != null && fileName.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: uploaded ? primary : const Color(0xFFFCE7F3)),
      ),
      child: Row(
        children: [
          Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                if (uploaded)
                  Text(fileName, style: const TextStyle(fontSize: 12, color: muted)),
              ],
            ),
          ),
          TextButton(
            onPressed: onPick,
            child: Text(uploaded ? 'Replace' : 'Upload',
                style: const TextStyle(color: primary, fontWeight: FontWeight.w700)),
          ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.delete_outline, color: muted),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)),
      );

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFCE7F3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboard,
    bool obscure = false,
    bool digitsOnly = false,
    int maxLines = 1,
    int? maxLength,
    String? hint,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        maxLength: maxLength,
        keyboardType: keyboard,
        onChanged: onChanged ?? (_) => setState(() {}),
        inputFormatters: [
          if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: _decoration(label, hint: hint),
      ),
    );
  }
}

class _DayHours {
  _DayHours({required this.start, required this.end, this.closed = false});
  final TextEditingController start;
  final TextEditingController end;
  bool closed;
}

class _SampleProduct {
  final name = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  String category = '';
  String? imageName;
}

class _CheckItem {
  const _CheckItem(this.label, this.ok, {this.warnIfMissing = false});
  final String label;
  final bool ok;
  final bool warnIfMissing;
}

class _ShopPreviewCard extends StatelessWidget {
  const _ShopPreviewCard({
    required this.businessName,
    required this.description,
    required this.categories,
    required this.subProducts,
    required this.theme,
    required this.logoName,
    required this.bannerName,
    required this.hours,
    required this.deliveryModes,
    required this.city,
  });

  final String businessName;
  final String description;
  final List<String> categories;
  final List<String> subProducts;
  final String theme;
  final String? logoName;
  final String? bannerName;
  final Map<String, _DayHours> hours;
  final List<String> deliveryModes;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFBCFE8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            color: const Color(0xFFFDA4AF),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            child: Text(
              bannerName == null ? 'Banner placeholder' : bannerName!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFFFE4E6),
                      child: Text(
                        () {
                          final raw = (logoName ?? businessName).trim();
                          return raw.isEmpty ? 'S' : raw[0].toUpperCase();
                        }(),
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFF43F5E)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(businessName.isEmpty ? 'Your shop name' : businessName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B))),
                          Text('$theme · $city', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description.isEmpty ? 'Shop description will appear here.' : description,
                  style: const TextStyle(color: Color(0xFF334155), height: 1.35),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in categories)
                      Chip(
                        label: Text(c, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        backgroundColor: const Color(0xFFFFE4E6),
                        visualDensity: VisualDensity.compact,
                      ),
                    for (final p in subProducts.take(6))
                      Chip(
                        label: Text(p, style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Working hours', style: TextStyle(fontWeight: FontWeight.w800)),
                for (final e in hours.entries)
                  Text(
                    e.value.closed
                        ? '${e.key}: Closed'
                        : '${e.key}: ${e.value.start.text}–${e.value.end.text}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                const SizedBox(height: 8),
                Text('Delivery: ${deliveryModes.join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
