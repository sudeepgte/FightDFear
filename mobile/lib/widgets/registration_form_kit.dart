import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

enum RegInputType {
  text,
  email,
  phone,
  password,
  multiline,
  dropdown,
  chips,
  number,
  file,
  multiFile,
  section,
}

class RegFieldDef {
  const RegFieldDef({
    required this.key,
    required this.label,
    this.type = RegInputType.text,
    this.initial = '',
    this.options = const [],
    this.required = false,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
  });

  final String key;
  final String label;
  final RegInputType type;
  final String initial;
  final List<String> options;
  final bool required;
  final String? hint;
  final int maxLines;
  final int? maxLength;
}

class RegValidators {
  /// Matches member / mobile auth backend password rule.
  static final RegExp passwordRule =
      RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$');

  static bool isEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());

  static bool isPhone10(String v) => RegExp(r'^\d{10}$').hasMatch(v.trim());

  static bool isPasswordStrong(String p) => passwordRule.hasMatch(p);

  static bool isOptionalUrl(String v) {
    final t = v.trim();
    if (t.isEmpty) return true;
    // Accept www.site.com, site.com, https://site.com/...
    return RegExp(
      r'^(https?:\/\/)?(www\.)?([\w-]+\.)+[\w-]{2,}(\/[^\s]*)?$',
      caseSensitive: false,
    ).hasMatch(t);
  }

  static bool isPositiveNumber(String v) {
    final n = num.tryParse(v.trim());
    return n != null && n >= 0;
  }

  static String? emailError(String v) {
    if (v.trim().isEmpty) return 'Email is required';
    if (!isEmail(v)) return 'Enter a valid email address';
    return null;
  }

  static String? phoneError(String v, {String label = 'Phone'}) {
    if (v.trim().isEmpty) return '$label is required';
    if (!isPhone10(v)) return '$label must be exactly 10 digits';
    return null;
  }

  static String? passwordError(String v) {
    if (v.isEmpty) return 'Password is required';
    if (!isPasswordStrong(v)) {
      return 'Min 6 chars with a number and special character (!@#\$%^&*)';
    }
    return null;
  }

  static String? confirmPasswordError(String password, String confirm) {
    if (confirm.isEmpty) return 'Confirm password is required';
    if (confirm != password) return 'Passwords do not match';
    return null;
  }

  static String? requiredText(String v, String label) {
    if (v.trim().isEmpty) return '$label is required';
    return null;
  }

  static int passwordScore(String p) {
    var s = 0;
    if (p.length >= 6) s++;
    if (p.length >= 10) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) s++;
    return s.clamp(0, 4);
  }

  static String passwordLabel(int score) {
    switch (score) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      default:
        return 'Strong';
    }
  }

  static Color passwordColor(int score) {
    switch (score) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.lightGreen;
      default:
        return Colors.green;
    }
  }
}

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    final score = RegValidators.passwordScore(password);
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 4,
              minHeight: 6,
              backgroundColor: Colors.black12,
              color: RegValidators.passwordColor(score),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            password.isEmpty ? 'Password strength' : 'Strength: ${RegValidators.passwordLabel(score)}',
            style: TextStyle(fontSize: 12, color: RegValidators.passwordColor(score)),
          ),
        ],
      ),
    );
  }
}

class ObscurePasswordField extends StatefulWidget {
  const ObscurePasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.showStrength = false,
    this.onChanged,
    this.filled = false,
    this.prefixIcon,
    this.errorText,
  });

  final TextEditingController controller;
  final String label;
  final bool showStrength;
  final ValueChanged<String>? onChanged;
  final bool filled;
  final IconData? prefixIcon;
  final String? errorText;

  @override
  State<ObscurePasswordField> createState() => _ObscurePasswordFieldState();
}

class _ObscurePasswordFieldState extends State<ObscurePasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          onChanged: (v) {
            widget.onChanged?.call(v);
            if (widget.showStrength) setState(() {});
          },
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: widget.errorText,
            filled: widget.filled,
            fillColor: widget.filled ? Colors.white : null,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, color: const Color(0xFFBE123C)),
            suffixIcon: IconButton(
              tooltip: _obscure ? 'Show password' : 'Hide password',
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
            border: widget.filled ? OutlineInputBorder(borderRadius: BorderRadius.circular(14)) : null,
            enabledBorder: widget.filled
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  )
                : null,
            focusedBorder: widget.filled
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
                  )
                : null,
          ),
        ),
        if (widget.showStrength) PasswordStrengthBar(password: widget.controller.text),
      ],
    );
  }
}

class ChipMultiSelect extends StatelessWidget {
  const ChipMultiSelect({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: options.map((o) {
              final on = selected.contains(o);
              return FilterChip(
                label: Text(o, style: const TextStyle(fontSize: 12)),
                selected: on,
                onSelected: (v) {
                  final next = {...selected};
                  if (v) {
                    next.add(o);
                  } else {
                    next.remove(o);
                  }
                  onChanged(next);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class FileUploadTile extends StatelessWidget {
  const FileUploadTile({
    super.key,
    required this.label,
    required this.fileName,
    required this.onPick,
    this.filePath,
    this.onClear,
    this.onPreview,
    this.hint = 'JPG, PNG or PDF up to 5 MB',
    this.optional = true,
  });

  final String label;
  final String? fileName;
  final String? filePath;
  final Future<void> Function() onPick;
  final VoidCallback? onClear;
  final Future<void> Function()? onPreview;
  final String hint;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final picked = fileName != null && fileName!.isNotEmpty;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  picked ? Icons.check_circle : Icons.upload_file_outlined,
                  color: picked ? Colors.green : Colors.black54,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$label${optional ? ' (optional)' : ' *'}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        picked ? fileName! : hint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!picked)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('Upload'),
                ),
              )
            else
              Wrap(
                spacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      if (onPreview != null) {
                        await onPreview!();
                        return;
                      }
                      await _defaultPreview(context);
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View'),
                  ),
                  TextButton.icon(
                    onPressed: onPick,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Replace'),
                  ),
                  TextButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _defaultPreview(BuildContext context) async {
    final path = filePath;
    final name = fileName ?? 'Document';
    final lower = name.toLowerCase();
    final isImage = lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.heic') ||
        lower.endsWith('.webp');

    if (path != null && path.isNotEmpty) {
      try {
        await OpenFile.open(path);
        return;
      } catch (_) {
        // Fall through to in-app dialog.
      }
    }

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path != null && path.isNotEmpty && isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(path),
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 48),
                ),
              )
            else ...[
              Icon(
                lower.endsWith('.pdf') ? Icons.picture_as_pdf_outlined : Icons.description_outlined,
                size: 48,
                color: const Color(0xFFF43F5E),
              ),
              const SizedBox(height: 8),
              Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                path == null || path.isEmpty
                    ? 'File selected for upload. Re-pick to enable full preview on this device.'
                    : 'Ready for submission',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

class OtpVerifyRow extends StatefulWidget {
  const OtpVerifyRow({
    super.key,
    required this.label,
    required this.verified,
    required this.onVerified,
  });

  final String label;
  final bool verified;
  final VoidCallback onVerified;

  @override
  State<OtpVerifyRow> createState() => _OtpVerifyRowState();
}

class _OtpVerifyRowState extends State<OtpVerifyRow> {
  final _otp = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verified) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.verified, color: Colors.green),
        title: Text('${widget.label} verified'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text('${widget.label} OTP verification')),
            TextButton(
              onPressed: () {
                setState(() => _sent = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Demo OTP sent for ${widget.label}. Use 123456.')),
                );
              },
              child: Text(_sent ? 'Resend OTP' : 'Send OTP'),
            ),
          ],
        ),
        if (_sent)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Enter OTP', hintText: '123456'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  if (_otp.text.trim() == '123456') {
                    widget.onVerified();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid OTP. Demo code is 123456.')),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ],
          ),
      ],
    );
  }
}

bool _isAllowedDocumentName(String name) {
  final lower = name.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.pdf');
}

Future<String?> pickImageName({bool fromCamera = false}) async {
  if (!fromCamera) {
    return pickDocumentName();
  }
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );
  if (file == null) return null;
  final name = file.name;
  if (!_isAllowedDocumentName(name) && !name.toLowerCase().endsWith('.heic')) {
    throw Exception('Only JPG, PNG, or PDF files are allowed');
  }
  return name;
}

/// Picks JPG / PNG / PDF and returns display name + local path for preview.
class PickedUpload {
  const PickedUpload({required this.name, this.path});
  final String name;
  final String? path;
}

Future<PickedUpload?> pickDocumentUpload() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
    withData: false,
  );
  if (result == null || result.files.isEmpty) return null;
  final file = result.files.first;
  final name = file.name;
  if (!_isAllowedDocumentName(name)) {
    throw Exception('Only JPG, PNG, or PDF files are allowed');
  }
  return PickedUpload(name: name, path: file.path);
}

Future<PickedUpload?> pickImageUpload({bool fromCamera = false}) async {
  if (!fromCamera) return pickDocumentUpload();
  final picker = ImagePicker();
  final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
  if (file == null) return null;
  final name = file.name;
  if (!_isAllowedDocumentName(name) && !name.toLowerCase().endsWith('.heic')) {
    throw Exception('Only JPG, PNG, or PDF files are allowed');
  }
  return PickedUpload(name: name, path: file.path);
}

/// Picks JPG / PNG / PDF via system file picker (supports multi-certificate uploads).
Future<String?> pickDocumentName() async {
  final picked = await pickDocumentUpload();
  return picked?.name;
}

Future<bool> showRegistrationPreviewDialog(
  BuildContext context, {
  required String title,
  required List<MapEntry<String, String>> rows,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Review your details before submitting.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            ...rows.where((e) => e.value.trim().isNotEmpty).map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.key, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                        Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Edit')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm & submit')),
      ],
    ),
  );
  return ok == true;
}

/// Multi-file upload with checkmarks and optional preview names.
class MultiFileUploadTile extends StatelessWidget {
  const MultiFileUploadTile({
    super.key,
    required this.label,
    required this.files,
    required this.onAdd,
    required this.onRemove,
    this.required = false,
    this.hint = 'JPG, PNG or PDF up to 5 MB',
  });

  final String label;
  final List<String> files;
  final Future<void> Function() onAdd;
  final ValueChanged<int> onRemove;
  final bool required;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$label${required ? ' *' : ' (optional)'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            Text(hint, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            if (files.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('No files uploaded yet', style: TextStyle(fontSize: 12)),
              )
            else
              ...files.asMap().entries.map((e) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  title: Text(e.value, overflow: TextOverflow.ellipsis),
                  subtitle: const Text('Tap to preview', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Document preview'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.description_outlined, size: 40),
                            const SizedBox(height: 8),
                            Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              e.value.toLowerCase().endsWith('.pdf')
                                  ? 'PDF document ready for submission'
                                  : 'Image document ready for submission',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                        ],
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => onRemove(e.key),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

Future<void> showRegistrationSuccessDialog(
  BuildContext context, {
  required String message,
  VoidCallback? onDone,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
      title: const Text('Registration submitted'),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onDone?.call();
          },
          child: const Text('Continue to Login'),
        ),
      ],
    ),
  );
}

/// Common option lists used across portals.
class RegOptions {
  static const orgTypes = [
    'NGO',
    'Company',
    'Educational Institution',
    'Government Department',
    'Community Organization',
    'Women Self Help Group',
    'Startup',
    'Fitness Organization',
    'Healthcare Organization',
    'Event Management Company',
    'Charity Foundation',
    'Sports Club',
    'Youth Organization',
  ];

  static const eventCategories = [
    'Women Safety',
    'Women Empowerment',
    'Self Defence',
    'Health Camp',
    'Blood Donation',
    'Yoga',
    'Marathon',
    'Mental Wellness',
    'Career Fair',
    'Startup Meetup',
    'Business Networking',
    'Education Workshop',
    'Coding Bootcamp',
    'Cultural Event',
    'Music Festival',
    'Art Exhibition',
    'Fashion Show',
    'Entrepreneurship',
    'Leadership Training',
    'Financial Literacy',
    'Legal Awareness',
    'Parenting',
    'Community Service',
  ];

  static const investorTypes = [
    'Angel Investor',
    'Venture Capital',
    'Private Investor',
    'Corporate Investor',
  ];

  static const investmentInterests = [
    'Technology',
    'Healthcare',
    'Education',
    'Women-led Startups',
    'FinTech',
    'AI',
    'Fashion',
    'Food',
  ];

  static const investmentRanges = [
    '₹1L–₹10L',
    '₹10L–₹50L',
    '₹50L–₹1Cr',
    '₹1Cr+',
  ];

  static const businessCategories = [
    'Food',
    'Fashion',
    'Technology',
    'Education',
    'Healthcare',
    'Beauty',
    'Handicrafts',
    'Retail',
    'Services',
  ];

  static const sellerCategories = [
    'Fashion',
    'Beauty',
    'Home Decor',
    'Organic Food',
    'Baby Products',
    'Jewellery',
    'Books',
    'Fitness',
  ];

  static const startupStages = ['Idea', 'Prototype', 'Early Revenue', 'Growth'];

  static const workTypes = ['Full-time', 'Part-time', 'Freelance'];

  static const availabilitySlots = ['Morning', 'Afternoon', 'Evening'];

  static const jobSkills = [
    'Cooking',
    'Cleaning',
    'Childcare',
    'Elder Care',
    'Tutoring',
    'Tailoring',
    'Beauty',
    'Customer Service',
    'Driving',
    'Computer Basics',
  ];

  static const jobCategories = [
    'Home Services',
    'Tutoring',
    'Beauty & Wellness',
    'Cooking & Catering',
    'Tailoring',
    'Childcare',
    'Elder Care',
    'Office Support',
    'Retail',
    'Events',
  ];

  static const marketplaceCategories = [
    'Tutor',
    'Tailor',
    'Home Cook',
    'Catering Service',
    'Event Planner',
    'Babysitter',
    'Pet Care',
    'Dietitian',
    'Home Cleaner',
    'Interior Designer',
    'Handicraft Seller',
    'Digital Marketing Consultant',
    'Home Baker',
    'Beautician',
    'Makeup Artist',
    'Mehendi Artist',
    'Photographer',
    'Yoga Trainer',
    'Fitness Trainer',
    'Dance Instructor',
    'Music Teacher',
    'Language Trainer',
    'Craft Seller',
    'Handmade Products',
    'Boutique',
    'Fashion Designer',
    'Freelancer',
    'Graphic Designer',
    'Content Writer',
  ];

  static const serviceTypes = ['Online', 'Offline', 'Both'];

  static const deliveryOptions = ['Pickup', 'Local Delivery', 'Courier'];

  static const weekDaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const weekDaysFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const salonServices = [
    'Hair Services',
    'Skin Care',
    'Makeup',
    'Nail Care',
    'Spa & Massage',
    'Waxing',
    'Threading',
    'Eye & Brow',
    'Bridal Services',
    'Mehendi',
    'Wellness',
    'Cosmetic Treatments',
    'Special Packages',
    'Training & Workshops',
  ];

  static const doctorAvailability = [
    '9:00 AM – 1:00 PM',
    '2:00 PM – 5:00 PM',
    '6:00 PM – 8:00 PM',
  ];

  static const doctorWorkingDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const consultationModes = [
    'In Clinic',
    'Online',
    'Home Visit',
  ];

  static const doctorLanguages = [
    'English',
    'Hindi',
    'Kannada',
    'Tamil',
    'Telugu',
    'Marathi',
    'Malayalam',
    'Bengali',
  ];

  static const medicalCouncils = [
    'NMC',
    'KMC',
    'MMC',
    'TMC',
    'DMC',
    'Other',
  ];

  static const doctorSpecialServices = [
    'High-Risk Pregnancy',
    'Fertility',
    'PCOS Care',
    'Menopause Care',
    'Adolescent Health',
    'Prenatal Care',
  ];

  static const centreTypes = ['Clinic', 'Hospital', 'NGO', 'Counselling Centre', 'Training Centre'];

  static const programModes = ['Online', 'Offline', 'Hybrid'];

  static const difficultyLevels = ['Beginner', 'Intermediate', 'Advanced'];

  static const ageGroups = ['18–25', '26–40', '41–55', 'All ages'];

  static const programDurations = ['1 month', '3 months', '6 months', '12 months'];

  static const indianStates = [
    'Andhra Pradesh',
    'Delhi',
    'Gujarat',
    'Karnataka',
    'Kerala',
    'Maharashtra',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
    'Other',
  ];
}
