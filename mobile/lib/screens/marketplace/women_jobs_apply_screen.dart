import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/registration_form_kit.dart';
import 'job_bookings_screen.dart';
import '../auth/login_screen.dart';

class WomenJobsApplyScreen extends StatefulWidget {
  const WomenJobsApplyScreen({super.key});

  @override
  State<WomenJobsApplyScreen> createState() => _WomenJobsApplyScreenState();
}

class _WomenJobsApplyScreenState extends State<WomenJobsApplyScreen> {
  String _category = RegOptions.jobCategories.first;
  final _sub = TextEditingController(text: 'General');
  final _rate = TextEditingController(text: '200');
  final _salary = TextEditingController();
  final _location = TextEditingController();
  final _languages = TextEditingController(text: 'Hindi, English');
  final _experience = TextEditingController(text: '1');
  final _note = TextEditingController();

  String _workType = RegOptions.workTypes.first;
  final Set<String> _skills = {};
  final Set<String> _availability = {};
  String? _resume;
  String? _photo;
  String? _govId;
  String? _portfolio;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _sub.dispose();
    _rate.dispose();
    _salary.dispose();
    _location.dispose();
    _languages.dispose();
    _experience.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthState>();
    if (!auth.loggedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
      if (!auth.loggedIn || !mounted) return;
    }
    if (_skills.isEmpty) {
      setState(() => _error = 'Select at least one skill.');
      return;
    }
    if (_availability.isEmpty) {
      setState(() => _error = 'Select availability.');
      return;
    }
    if (_experience.text.trim().isEmpty || !RegValidators.isPositiveNumber(_experience.text)) {
      setState(() => _error = 'Enter valid years of experience.');
      return;
    }
    if ((_rate.text.trim().isEmpty) || (double.tryParse(_rate.text.trim()) ?? -1) < 0) {
      setState(() => _error = 'Enter a valid hourly rate.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final note = [
        _note.text.trim(),
        'Experience: ${_experience.text.trim()} yrs',
        'Skills: ${_skills.join(', ')}',
        'Work type: $_workType',
        if (_location.text.trim().isNotEmpty) 'Preferred location: ${_location.text.trim()}',
        'Availability: ${_availability.join(', ')}',
        if (_languages.text.trim().isNotEmpty) 'Languages: ${_languages.text.trim()}',
        if (_salary.text.trim().isNotEmpty) 'Expected salary: ₹${_salary.text.trim()}',
        if (_resume != null) 'Resume: $_resume',
        if (_photo != null) 'Photo: $_photo',
        if (_govId != null) 'ID: $_govId',
        if (_portfolio != null) 'Portfolio: $_portfolio',
      ].where((e) => e.isNotEmpty).join('\n');

      final res = await MarketplaceService(auth.api).applyJob(
        category: _category,
        subCategory: _sub.text.trim().isEmpty ? 'General' : _sub.text.trim(),
        hourlyRate: double.tryParse(_rate.text.trim()) ?? 0,
        note: note,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await showRegistrationSuccessDialog(
          context,
          message:
              'Application submitted successfully. Your profile is under review and will be visible to employers after admin approval.',
          onDone: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const JobBookingsScreen(workerView: true)),
            );
          },
        );
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Apply failed');
      }
    } catch (e) {
      setState(() => _error = '$e');
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Women Jobs — Apply')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Apply as a verified worker. Admin approval is required before clients can book you.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Job category *'),
            items: RegOptions.jobCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          TextField(controller: _sub, decoration: const InputDecoration(labelText: 'Sub-category')),
          TextField(
            controller: _experience,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Years of experience *'),
          ),
          ChipMultiSelect(
            label: 'Skills *',
            options: RegOptions.jobSkills,
            selected: _skills,
            onChanged: (s) => setState(() {
              _skills
                ..clear()
                ..addAll(s);
            }),
          ),
          DropdownButtonFormField<String>(
            value: _workType,
            decoration: const InputDecoration(labelText: 'Preferred work type *'),
            items: RegOptions.workTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _workType = v ?? _workType),
          ),
          TextField(controller: _location, decoration: const InputDecoration(labelText: 'Preferred location')),
          ChipMultiSelect(
            label: 'Availability *',
            options: RegOptions.availabilitySlots,
            selected: _availability,
            onChanged: (s) => setState(() {
              _availability
                ..clear()
                ..addAll(s);
            }),
          ),
          TextField(controller: _languages, decoration: const InputDecoration(labelText: 'Languages known')),
          TextField(
            controller: _rate,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Expected hourly rate (₹) *'),
          ),
          if (_workType == 'Full-time')
            TextField(
              controller: _salary,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Expected monthly salary (optional)'),
            ),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Additional note'),
          ),
          FileUploadTile(
            label: 'Resume (PDF/image)',
            fileName: _resume,
            onPick: () async {
              final n = await pickImageName();
              if (n != null) setState(() => _resume = n);
            },
          ),
          FileUploadTile(
            label: 'Profile photo',
            fileName: _photo,
            onPick: () async {
              final n = await pickImageName();
              if (n != null) setState(() => _photo = n);
            },
          ),
          FileUploadTile(
            label: 'Government ID verification',
            fileName: _govId,
            onPick: () async {
              final n = await pickImageName();
              if (n != null) setState(() => _govId = n);
            },
          ),
          FileUploadTile(
            label: 'Portfolio / certificates',
            fileName: _portfolio,
            onPick: () async {
              final n = await pickImageName();
              if (n != null) setState(() => _portfolio = n);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit Application'),
          ),
        ],
      ),
    );
  }
}
