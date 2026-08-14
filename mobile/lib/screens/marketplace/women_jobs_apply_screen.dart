import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../config/job_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/registration_form_kit.dart';
import '../auth/login_screen.dart';
import 'women_jobs_application_status_screen.dart';

class WomenJobsApplyScreen extends StatefulWidget {
  const WomenJobsApplyScreen({
    super.key,
    this.asProfileCompletion = false,
    this.initialCategory,
    this.onFinished,
  });

  /// After quick register/login — extra worker details, Skip allowed.
  final bool asProfileCompletion;
  final String? initialCategory;
  final void Function(BuildContext context)? onFinished;

  @override
  State<WomenJobsApplyScreen> createState() => _WomenJobsApplyScreenState();
}

class _WomenJobsApplyScreenState extends State<WomenJobsApplyScreen> {
  String _category = JobCatalog.categories.first;
  late String _sub;
  final _rate = TextEditingController(text: '200');
  final _salary = TextEditingController();
  final _location = TextEditingController();
  final _languages = TextEditingController(text: 'Hindi, English');
  final _experience = TextEditingController(text: '1');
  final _note = TextEditingController();

  String _workType = RegOptions.workTypes.first;
  final Set<String> _skills = {};
  final Set<String> _availability = {};
  PickedUpload? _document;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final initial = JobCatalog.normalize(widget.initialCategory);
    if (initial != null && JobCatalog.categories.contains(initial)) {
      _category = initial;
    }
    final subs = JobCatalog.subsFor(_category);
    _sub = subs.isEmpty ? 'General' : subs.first;
  }

  void _goNext() {
    if (widget.onFinished != null) {
      widget.onFinished!(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WomenJobsApplicationStatusScreen()),
      );
    }
  }

  @override
  void dispose() {
    _rate.dispose();
    _salary.dispose();
    _location.dispose();
    _languages.dispose();
    _experience.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final auth = context.read<AuthState>();
    if (!auth.loggedIn) {
      if (widget.asProfileCompletion) {
        setState(() => _error = 'Please login first.');
        return;
      }
      final loggedIn = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const LoginScreen(popOnSuccess: true)),
      );
      if (loggedIn != true || !auth.loggedIn || !mounted) return;
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
    final rate = double.tryParse(_rate.text.trim());
    if (rate == null || rate < 0) {
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
        if (_salary.text.trim().isNotEmpty) 'Expected salary: Rs ${_salary.text.trim()}',
      ].where((e) => e.isNotEmpty).join('\n');

      final res = await MarketplaceService(auth.api).applyJob(
        category: _category,
        subCategory: _sub,
        hourlyRate: rate,
        note: note,
        documentPath: _document?.path,
        documentName: _document?.name,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            title: const Text('Application submitted'),
            content: const Text(
              'Your profile is under review and will be visible to clients after admin approval.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('View status'),
              ),
            ],
          ),
        );
        if (!mounted) return;
        _goNext();
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Apply failed');
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final subs = JobCatalog.subsFor(_category);
    final subValue = subs.contains(_sub) ? _sub : (subs.isEmpty ? _sub : subs.first);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.asProfileCompletion
            ? 'Complete worker profile'
            : 'Women Jobs — Apply'),
        actions: [
          if (widget.asProfileCompletion)
            TextButton(
              onPressed: _goNext,
              child: const Text('Skip for now'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.asProfileCompletion
                ? 'Add the details employers will see. You can skip and finish this later. Admin approval is required before clients can book you.'
                : 'Apply as a verified worker. Admin approval is required before clients can book you.',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          DropdownButtonFormField<String>(
            key: ValueKey('cat_$_category'),
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Job category *'),
            items: JobCatalog.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: _loading
                ? null
                : (v) => setState(() {
                      _category = v ?? _category;
                      final next = JobCatalog.subsFor(_category);
                      _sub = next.isEmpty ? _sub : next.first;
                    }),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            key: ValueKey('sub_$subValue'),
            initialValue: subValue,
            decoration: const InputDecoration(labelText: 'Specific role *'),
            items: subs.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: _loading ? null : (v) => setState(() => _sub = v ?? _sub),
          ),
          TextField(
            controller: _experience,
            enabled: !_loading,
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
            initialValue: _workType,
            decoration: const InputDecoration(labelText: 'Preferred work type *'),
            items: RegOptions.workTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: _loading ? null : (v) => setState(() => _workType = v ?? _workType),
          ),
          TextField(controller: _location, enabled: !_loading, decoration: const InputDecoration(labelText: 'Preferred location')),
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
          TextField(controller: _languages, enabled: !_loading, decoration: const InputDecoration(labelText: 'Languages known')),
          TextField(
            controller: _rate,
            enabled: !_loading,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Expected hourly rate (₹) *'),
          ),
          if (_workType == 'Full-time')
            TextField(
              controller: _salary,
              enabled: !_loading,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Expected monthly salary (optional)'),
            ),
          TextField(
            controller: _note,
            enabled: !_loading,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Additional note'),
          ),
          FileUploadTile(
            label: 'Proof document (resume / ID / certificate)',
            fileName: _document?.name,
            optional: true,
            onPick: () async {
              if (_loading) return;
              try {
                final picked = await pickDocumentUpload();
                if (picked != null) setState(() => _document = picked);
              } catch (e) {
                if (mounted) setState(() => _error = '$e');
              }
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
