import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/marketplace_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../../widgets/ux_feedback.dart';

/// Complete marketplace provider profile after quick registration.
class MarketplaceProviderProfileCompletionScreen extends StatefulWidget {
  const MarketplaceProviderProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MarketplaceProviderProfileCompletionScreen> createState() =>
      _MarketplaceProviderProfileCompletionScreenState();
}

class _MarketplaceProviderProfileCompletionScreenState
    extends State<MarketplaceProviderProfileCompletionScreen> {
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();

  String _category = MarketplaceCatalog.servicePartnerCodes.first;
  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _profile = {};

  MarketplaceProviderAuthService get _svc =>
      MarketplaceProviderAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_fullName, _phone, _description, _location]) {
      c.dispose();
    }
    super.dispose();
  }

  String _categoryCode(String? raw) {
    final code = MarketplaceCatalog.codeFor(raw);
    if (code != null && MarketplaceCatalog.servicePartnerCodes.contains(code)) {
      return code;
    }
    return MarketplaceCatalog.servicePartnerCodes.first;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _svc.profile();
    if (!mounted) return;
    if (res['success'] == true) {
      _applyProfile(Map<String, dynamic>.from(res));
      setState(() => _loading = false);
    } else {
      setState(() {
        _loading = false;
        _error = res['error']?.toString() ?? 'Failed to load profile';
      });
    }
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    _fullName.text = p['fullName']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _description.text = p['description']?.toString() ?? '';
    _location.text = p['locationText']?.toString() ?? '';
    _category = _categoryCode(p['category']?.toString());
  }

  List<String> _missing() {
    final raw = _profile['missingItems'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }

  Future<void> _saveProfile() async {
    if (_fullName.text.trim().isEmpty) {
      setState(() => _error = 'Full name is required.');
      return;
    }
    final phoneErr = RegValidators.phoneError(_phone.text);
    if (phoneErr != null) {
      setState(() => _error = phoneErr);
      return;
    }
    if (_description.text.trim().isEmpty) {
      setState(() => _error = 'Description is required.');
      return;
    }
    if (_location.text.trim().isEmpty) {
      setState(() => _error = 'Location / service area is required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final res = await _svc.updateProfile({
      'fullName': _fullName.text.trim(),
      'phone': _phone.text.trim(),
      'description': _description.text.trim(),
      'locationText': _location.text.trim(),
      'category': _category,
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (res['success'] == true) {
      _applyProfile(Map<String, dynamic>.from(res));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Save failed');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    await _saveProfile();
    final res = await _svc.submitVerification();
    if (!mounted) return;
    setState(() => _submitting = false);
    if (res['success'] == true) {
      _applyProfile(Map<String, dynamic>.from(res));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']?.toString() ?? 'Submitted for verification'),
        ),
      );
      if (widget.onFinished != null) {
        widget.onFinished!(context);
      } else {
        Navigator.of(context).pop(true);
      }
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Submit failed');
      await _load();
    }
  }

  void _goToDashboard() {
    if (widget.onFinished != null) {
      widget.onFinished!(context);
    } else {
      Navigator.of(context).pop(false);
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'REGISTERED':
        return 'Registered';
      case 'PROFILE_INCOMPLETE':
        return 'Profile Incomplete';
      case 'READY_FOR_VERIFICATION':
        return 'Ready to Submit';
      case 'PENDING_ADMIN_APPROVAL':
        return 'Pending Approval';
      case 'CHANGES_REQUESTED':
        return 'Changes Requested';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'SUSPENDED':
        return 'Suspended';
      default:
        return status ?? 'Profile Incomplete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toDouble()
        : double.tryParse('${_profile['profileCompletionPct']}') ?? 0;
    final status =
        _profile['partnerProfileStatus']?.toString() ?? 'PROFILE_INCOMPLETE';
    final statusLabel =
        (_profile['partnerProfileStatusLabel'] ?? _statusLabel(status)).toString();
    final missing = _missing();
    final canSubmit = _profile['canSubmitForVerification'] == true;
    final guidance = _profile['nextStepGuidance']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MarketplaceProviderProfileCompletionScreen.navy,
        title: const Text(
          'Complete Partner Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: _goToDashboard,
            child: const Text('Skip for now'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                const Text(
                  'You can skip for now, but adding classes is disabled until admin approval.',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 12),
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: statusLabel,
                  hint: ProfileCompletionCard.hintFromMissing(missing, guidance: guidance),
                  actionLabel: '',
                  onAction: () {},
                  showActionButton: false,
                  trailing: missing.isEmpty
                      ? null
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: missing
                              .map(
                                (m) => Chip(
                                  label: Text(m, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: const Color(0xFFFFF7ED),
                                ),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: MarketplaceProviderProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          canSubmit
                              ? 'Submit for Verification'
                              : 'Complete required items to submit',
                        ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                _sectionTitle('Service details'),
                _field(_fullName, 'Full name *'),
                _field(_phone, 'Phone', keyboard: TextInputType.phone),
                if ((_profile['rejectionReason']?.toString() ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Rejection: ${_profile['rejectionReason']}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                if ((_profile['changesRequestedNote']?.toString() ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Changes requested: ${_profile['changesRequestedNote']}',
                      style: const TextStyle(color: Color(0xFFB45309)),
                    ),
                  ),
                DropdownButtonFormField<String>(
                  key: ValueKey('cat_$_category'),
                  initialValue: MarketplaceCatalog.servicePartnerCodes.contains(_category)
                      ? _category
                      : MarketplaceCatalog.servicePartnerCodes.first,
                  decoration: const InputDecoration(
                    labelText: 'Service category *',
                    border: OutlineInputBorder(),
                  ),
                  items: MarketplaceCatalog.servicePartnerItems
                      .map((c) => DropdownMenuItem(value: c.code, child: Text(c.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? _category),
                ),
                const SizedBox(height: 12),
                _field(_description, 'Description *', maxLines: 4),
                _field(_location, 'Location / service area *', maxLines: 3),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save details'),
                ),
              ],
            ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: MarketplaceProviderProfileCompletionScreen.navy,
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
