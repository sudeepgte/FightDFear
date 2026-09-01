import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/registration_form_kit.dart';

typedef PortalAuthSubmit = Future<Map<String, dynamic>> Function({
  required bool register,
  required String email,
  required String password,
  required Map<String, String> extra,
});

typedef PortalEmailOtpSender = Future<Map<String, dynamic>> Function(String email);
typedef PortalEmailOtpVerifier = Future<Map<String, dynamic>> Function({
  required String email,
  required String otp,
});
typedef PortalLoginSuccess = Future<void> Function(
  BuildContext context,
  Map<String, dynamic> response,
);

/// Shared login/register UI for provider portals with rich registration fields.
class PortalAuthScreen extends StatefulWidget {
  const PortalAuthScreen({
    super.key,
    required this.title,
    required this.registerFields,
    required this.onSubmit,
    required this.dashboardBuilder,
    this.defaultRegister = false,
    this.successMessage =
        'Registration submitted successfully. Your account is under verification and will be activated after admin approval.',
    this.requireTerms = true,
    this.requireEmailOtp = true,
    this.requirePhoneOtp = true,
    this.loginSubtitle,
    this.loginIcon = Icons.business_center_rounded,
    this.onCreateAccount,
    this.onSendEmailOtp,
    this.onVerifyEmailOtp,
    this.onLoginSuccess,
  });

  final String title;
  final List<RegFieldDef> registerFields;
  final PortalAuthSubmit onSubmit;
  final WidgetBuilder dashboardBuilder;
  final bool defaultRegister;
  final String successMessage;
  final bool requireTerms;
  final bool requireEmailOtp;
  final bool requirePhoneOtp;
  final String? loginSubtitle;
  final IconData loginIcon;
  /// When set, "Create account" opens this flow instead of the inline register form.
  final VoidCallback? onCreateAccount;
  /// Real email OTP send (when set, replaces demo OTP).
  final PortalEmailOtpSender? onSendEmailOtp;
  /// Real email OTP verify (when set, replaces demo OTP).
  final PortalEmailOtpVerifier? onVerifyEmailOtp;
  /// Override post-login navigation (e.g. profile completion then dashboard).
  final PortalLoginSuccess? onLoginSuccess;

  @override
  State<PortalAuthScreen> createState() => _PortalAuthScreenState();
}

class _PortalAuthScreenState extends State<PortalAuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  late final Map<String, TextEditingController> _text;
  late final Map<String, String?> _dropdowns;
  late final Map<String, Set<String>> _chips;
  late final Map<String, String?> _files;
  late final Map<String, String?> _filePaths;
  late final Map<String, List<String>> _multiFiles;
  final Map<String, String> _fieldErrors = {};
  bool _loading = false;
  bool _uploading = false;
  bool _register = false;
  bool _terms = false;
  bool _emailOtpOk = false;
  bool _phoneOtpOk = false;
  bool _touched = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _register = widget.defaultRegister;
    _text = {};
    _dropdowns = {};
    _chips = {};
    _files = {};
    _filePaths = {};
    _multiFiles = {};
    for (final f in widget.registerFields) {
      switch (f.type) {
        case RegInputType.dropdown:
          _dropdowns[f.key] =
              f.initial.isNotEmpty ? f.initial : (f.options.isNotEmpty ? f.options.first : null);
        case RegInputType.chips:
          _chips[f.key] = {
            if (f.initial.isNotEmpty)
              ...f.initial.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
          };
        case RegInputType.file:
          _files[f.key] = null;
          _filePaths[f.key] = null;
        case RegInputType.multiFile:
          _multiFiles[f.key] = [];
        case RegInputType.section:
          break;
        default:
          _text[f.key] = TextEditingController(text: f.initial);
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _valueOf(RegFieldDef f) {
    return switch (f.type) {
      RegInputType.dropdown => _dropdowns[f.key] ?? '',
      RegInputType.chips => (_chips[f.key] ?? {}).join(', '),
      RegInputType.file => _files[f.key] ?? '',
      RegInputType.multiFile => (_multiFiles[f.key] ?? []).join(', '),
      RegInputType.section => '',
      _ => _text[f.key]?.text.trim() ?? '',
    };
  }

  Map<String, String> _collectExtra() {
    final extra = <String, String>{};
    for (final e in _text.entries) {
      extra[e.key] = e.value.text.trim();
    }
    for (final e in _dropdowns.entries) {
      extra[e.key] = e.value ?? '';
    }
    for (final e in _chips.entries) {
      extra[e.key] = e.value.join(', ');
    }
    for (final e in _files.entries) {
      extra[e.key] = e.value == null || e.value!.isEmpty ? 'mobile-pending' : 'mobile:${e.value}';
    }
    for (final e in _multiFiles.entries) {
      extra[e.key] = e.value.isEmpty
          ? 'mobile-pending'
          : e.value.map((n) => 'mobile:$n').join('|');
    }
    extra['confirmPassword'] = _confirmPassword.text;
    extra['acceptedTerms'] = _terms ? 'true' : 'false';
    return extra;
  }

  Map<String, String> _computeFieldErrors() {
    final errors = <String, String>{};
    if (!_register) {
      final e = RegValidators.emailError(_email.text);
      if (e != null) errors['email'] = e;
      if (_password.text.isEmpty) errors['password'] = 'Password is required';
      return errors;
    }

    for (final f in widget.registerFields) {
      if (f.type == RegInputType.section) continue;
      final v = _valueOf(f);

      if (f.required) {
        if (f.type == RegInputType.chips && (_chips[f.key] ?? {}).isEmpty) {
          errors[f.key] = '${f.label} is required';
          continue;
        }
        if (f.type == RegInputType.file && (v.isEmpty)) {
          errors[f.key] = '${f.label} is required';
          continue;
        }
        if (f.type == RegInputType.multiFile && (_multiFiles[f.key] ?? []).isEmpty) {
          errors[f.key] = '${f.label} is required';
          continue;
        }
        if (f.type != RegInputType.chips &&
            f.type != RegInputType.file &&
            f.type != RegInputType.multiFile &&
            v.isEmpty) {
          errors[f.key] = '${f.label} is required';
          continue;
        }
      }

      if (v.isEmpty) continue;

      if (f.type == RegInputType.phone || f.key.toLowerCase().contains('phone')) {
        final err = RegValidators.phoneError(v, label: f.label);
        if (err != null) errors[f.key] = err;
      } else if (f.type == RegInputType.email) {
        final err = RegValidators.emailError(v);
        if (err != null) errors[f.key] = err;
      } else if (f.type == RegInputType.number) {
        if (!RegValidators.isPositiveNumber(v)) {
          errors[f.key] = '${f.label} must be a valid number';
        }
      } else if (f.key.toLowerCase().contains('website')) {
        if (!RegValidators.isOptionalUrl(v)) {
          errors[f.key] = 'Enter a valid website URL';
        }
      }
    }

    final emailErr = RegValidators.emailError(_email.text);
    if (emailErr != null) errors['email'] = emailErr;
    final passErr = RegValidators.passwordError(_password.text);
    if (passErr != null) errors['password'] = passErr;
    final confirmErr = RegValidators.confirmPasswordError(_password.text, _confirmPassword.text);
    if (confirmErr != null) errors['confirmPassword'] = confirmErr;
    if (widget.requireTerms && !_terms) errors['terms'] = 'Please accept Terms & Conditions';
    if (widget.requireEmailOtp && !_emailOtpOk) errors['emailOtp'] = 'Please verify email OTP';
    if (widget.requirePhoneOtp && !_phoneOtpOk) errors['phoneOtp'] = 'Please verify phone OTP';
    return errors;
  }

  bool get _canSubmit {
    if (_loading || _uploading) return false;
    // Login: always allow tap so we can show validation errors (disabled gray button felt broken).
    if (!_register) return true;
    return _computeFieldErrors().isEmpty;
  }

  /// Live format checks while editing — never block the whole form with
  /// submit-only errors (OTP / terms / password) until the user tries Submit.
  void _refreshValidation() {
    if (!_touched) {
      setState(() {
        // Keep only format errors for fields the user already typed into.
        final next = <String, String>{};
        final emailErr = RegValidators.emailError(_email.text);
        if (_email.text.trim().isNotEmpty && emailErr != null) {
          next['email'] = emailErr;
        }
        for (final f in widget.registerFields) {
          if (!_register || f.type == RegInputType.section) continue;
          final v = _valueOf(f);
          if (v.isEmpty) continue;
          if (f.type == RegInputType.phone || f.key.toLowerCase().contains('phone')) {
            final err = RegValidators.phoneError(v, label: f.label);
            if (err != null) next[f.key] = err;
          }
        }
        if (_register && _password.text.isNotEmpty) {
          final passErr = RegValidators.passwordError(_password.text);
          if (passErr != null) next['password'] = passErr;
        }
        if (_register && _confirmPassword.text.isNotEmpty) {
          final confirmErr =
              RegValidators.confirmPasswordError(_password.text, _confirmPassword.text);
          if (confirmErr != null) next['confirmPassword'] = confirmErr;
        }
        _fieldErrors
          ..clear()
          ..addAll(next);
      });
      return;
    }
    setState(() {
      _fieldErrors
        ..clear()
        ..addAll(_computeFieldErrors());
    });
  }

  /// Validate prerequisites for Send OTP and surface errors next to fields.
  bool _validateBeforeSendEmailOtp() {
    final email = _email.text.trim();
    final emailErr = RegValidators.emailError(email);
    String? phoneErr;
    for (final f in widget.registerFields) {
      if (f.type == RegInputType.phone || f.key.toLowerCase().contains('phone')) {
        phoneErr = RegValidators.phoneError(_valueOf(f), label: f.label);
        break;
      }
    }
    setState(() {
      if (emailErr != null) {
        _fieldErrors['email'] = emailErr;
      } else {
        _fieldErrors.remove('email');
      }
      if (phoneErr != null) {
        final phoneKey = widget.registerFields
            .firstWhere(
              (f) => f.type == RegInputType.phone || f.key.toLowerCase().contains('phone'),
              orElse: () => const RegFieldDef(key: 'phone', label: 'Phone'),
            )
            .key;
        _fieldErrors[phoneKey] = phoneErr;
      }
      _error = emailErr ?? phoneErr;
    });
    if (emailErr != null || phoneErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailErr ?? phoneErr!)),
      );
      return false;
    }
    return true;
  }

  InputDecoration _fieldDecoration({
    required String label,
    String? errorText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: const Color(0xFFBE123C)),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _touched = true;
      _fieldErrors
        ..clear()
        ..addAll(_computeFieldErrors());
      _error = null;
    });
    if (_fieldErrors.isNotEmpty) {
      setState(() => _error = _fieldErrors.values.first);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_fieldErrors.values.first)));
      return;
    }

    if (_register) {
      final previewRows = <MapEntry<String, String>>[
        MapEntry('Email', _email.text.trim()),
        ...widget.registerFields
            .where((f) => f.type != RegInputType.section && f.type != RegInputType.password)
            .map((f) => MapEntry(f.label, _valueOf(f))),
      ];
      final confirmed = await showRegistrationPreviewDialog(
        context,
        title: 'Preview ${widget.title} registration',
        rows: previewRows,
      );
      if (!confirmed || !mounted) return;
    }

    setState(() => _loading = true);
    var loadingOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Submitting registration…'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    void closeLoading() {
      if (!loadingOpen || !mounted) return;
      loadingOpen = false;
      Navigator.of(context, rootNavigator: true).pop();
    }

    try {
      final res = await widget.onSubmit(
        register: _register,
        email: _email.text.trim(),
        password: _password.text,
        extra: _collectExtra(),
      );
      closeLoading();
      if (!mounted) return;

      final ok = res['success'] == true || res['success']?.toString().toLowerCase() == 'true';
      if (ok) {
        if (_register) {
          await showRegistrationSuccessDialog(
            context,
            message: res['message']?.toString() ?? widget.successMessage,
            onDone: () => setState(() {
              _register = false;
              _terms = false;
              _emailOtpOk = false;
              _phoneOtpOk = false;
              _touched = false;
              _fieldErrors.clear();
              _error = null;
            }),
          );
        } else {
          if (widget.onLoginSuccess != null) {
            await widget.onLoginSuccess!(context, res);
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: widget.dashboardBuilder),
            );
          }
        }
      } else {
        final err = res['error']?.toString() ?? res['message']?.toString() ?? 'Action failed';
        setState(() => _error = err);
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Registration failed'),
            content: Text(err),
            actions: [
              FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
            ],
          ),
        );
      }
    } catch (e) {
      closeLoading();
      if (!mounted) return;
      final err = e.toString().contains('TimeoutException')
          ? 'Server took too long to respond. Check that the backend is running on port 8084, then try again.'
          : '$e';
      setState(() => _error = err);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration failed'),
          content: Text(err),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      );
    }
    if (mounted) setState(() => _loading = false);
  }

  Widget _errorText(String key) {
    final msg = _fieldErrors[key];
    if (msg == null || msg.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: Text(msg, style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }

  Widget _buildField(RegFieldDef f) {
    switch (f.type) {
      case RegInputType.section:
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 6),
          child: Text(
            f.label,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E1B4B)),
          ),
        );
      case RegInputType.dropdown:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _dropdowns[f.key],
              decoration: InputDecoration(
                labelText: '${f.label}${f.required ? ' *' : ''}',
                errorText: _fieldErrors[f.key],
              ),
              items: f.options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) {
                setState(() => _dropdowns[f.key] = v);
                _refreshValidation();
              },
            ),
          ],
        );
      case RegInputType.chips:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChipMultiSelect(
              label: '${f.label}${f.required ? ' *' : ''}',
              options: f.options,
              selected: _chips[f.key] ?? {},
              onChanged: (s) {
                setState(() => _chips[f.key] = s);
                _refreshValidation();
              },
            ),
            _errorText(f.key),
          ],
        );
      case RegInputType.file:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileUploadTile(
              label: f.label,
              fileName: _files[f.key],
              filePath: _filePaths[f.key],
              optional: !f.required,
              hint: f.hint ?? 'JPG, PNG or PDF up to 5 MB',
              onPick: () async {
                setState(() => _uploading = true);
                try {
                  final picked = await pickDocumentUpload();
                  if (picked != null) {
                    setState(() {
                      _files[f.key] = picked.name;
                      _filePaths[f.key] = picked.path;
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Uploaded ${picked.name} ✓')),
                      );
                    }
                    _refreshValidation();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _uploading = false);
                }
              },
              onClear: () {
                setState(() {
                  _files[f.key] = null;
                  _filePaths[f.key] = null;
                });
                _refreshValidation();
              },
            ),
            if (_uploading)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            _errorText(f.key),
          ],
        );
      case RegInputType.multiFile:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MultiFileUploadTile(
              label: f.label,
              required: f.required,
              hint: f.hint ?? 'JPG, PNG or PDF up to 5 MB · tap Add for each certificate',
              files: _multiFiles[f.key] ?? const [],
              onAdd: () async {
                setState(() => _uploading = true);
                try {
                  final name = await pickImageName();
                  if (name != null) {
                    setState(() {
                      (_multiFiles[f.key] ??= []).add(name);
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added $name ✓')),
                      );
                    }
                    _refreshValidation();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _uploading = false);
                }
              },
              onRemove: (i) {
                setState(() => (_multiFiles[f.key] ?? []).removeAt(i));
                _refreshValidation();
              },
            ),
            if (_uploading)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            _errorText(f.key),
          ],
        );
      case RegInputType.multiline:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _text[f.key],
              maxLines: f.maxLines > 1 ? f.maxLines : 3,
              maxLength: f.maxLength,
              onChanged: (_) => _refreshValidation(),
              decoration: InputDecoration(
                labelText: '${f.label}${f.required ? ' *' : ''}',
                hintText: f.hint,
                alignLabelWithHint: true,
                errorText: _fieldErrors[f.key],
              ),
            ),
          ],
        );
      case RegInputType.phone:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _text[f.key],
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (_) {
                if (f.key.toLowerCase().contains('phone') && widget.requirePhoneOtp) {
                  _phoneOtpOk = false;
                }
                _refreshValidation();
              },
              decoration: InputDecoration(
                labelText: '${f.label}${f.required ? ' *' : ''}',
                hintText: f.hint ?? '10-digit mobile',
                errorText: _fieldErrors[f.key],
              ),
            ),
          ],
        );
      case RegInputType.number:
        return TextField(
          controller: _text[f.key],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => _refreshValidation(),
          decoration: InputDecoration(
            labelText: '${f.label}${f.required ? ' *' : ''}',
            errorText: _fieldErrors[f.key],
          ),
        );
      case RegInputType.email:
        return TextField(
          controller: _text[f.key],
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _refreshValidation(),
          decoration: InputDecoration(
            labelText: '${f.label}${f.required ? ' *' : ''}',
            errorText: _fieldErrors[f.key],
          ),
        );
      case RegInputType.password:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ObscurePasswordField(
              controller: _text[f.key]!,
              label: '${f.label}${f.required ? ' *' : ''}',
              onChanged: (_) => _refreshValidation(),
            ),
            _errorText(f.key),
          ],
        );
      case RegInputType.text:
        return TextField(
          controller: _text[f.key],
          onChanged: (_) => _refreshValidation(),
          decoration: InputDecoration(
            labelText: '${f.label}${f.required ? ' *' : ''}',
            hintText: f.hint,
            errorText: _fieldErrors[f.key],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthState>();
    final canSubmit = _canSubmit;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F2),
      appBar: AppBar(
        title: Text(_register ? '${widget.title} Join' : '${widget.title} Login'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E1B4B),
        elevation: 0,
      ),
      extendBodyBehindAppBar: !_register,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE4E6),
              Color(0xFFFFF1F2),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: _register ? _buildRegisterForm(canSubmit) : _buildLoginCard(canSubmit),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool canSubmit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/fightdfear-logo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(widget.loginIcon, size: 40, color: const Color(0xFFF43F5E)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1B4B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.loginSubtitle ?? 'Sign in to manage your ${widget.title.toLowerCase()} account',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13)),
                ),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_touched) _refreshValidation();
                  setState(() {});
                },
                decoration: _fieldDecoration(
                  label: 'Email',
                  errorText: _fieldErrors['email'],
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 14),
              ObscurePasswordField(
                controller: _password,
                label: 'Password',
                filled: true,
                prefixIcon: Icons.lock_outline,
                errorText: _fieldErrors['password'],
                onChanged: (_) {
                  if (_touched) _refreshValidation();
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFF43F5E).withValues(alpha: 0.45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: canSubmit ? _submit : null,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _loading
              ? null
              : () {
                  if (widget.onCreateAccount != null) {
                    widget.onCreateAccount!();
                    return;
                  }
                  setState(() {
                    _register = true;
                    _error = null;
                    _touched = false;
                    _fieldErrors.clear();
                  });
                },
          child: const Text.rich(
            TextSpan(
              text: 'New here? ',
              style: TextStyle(color: Color(0xFF64748B)),
              children: [
                TextSpan(
                  text: 'Create account',
                  style: TextStyle(color: Color(0xFFBE123C), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool canSubmit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Join as ${widget.title}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Complete your profile. Account activates after admin verification.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
        ),
        const SizedBox(height: 16),
        if (_error != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_error!, style: TextStyle(color: Colors.red.shade800)),
          ),
        ...widget.registerFields.map(_buildField),
        const SizedBox(height: 8),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) {
            if (widget.requireEmailOtp) _emailOtpOk = false;
            _refreshValidation();
          },
          decoration: _fieldDecoration(
            label: 'Email *',
            errorText: _fieldErrors['email'],
            prefixIcon: Icons.email_outlined,
          ),
        ),
        if (widget.requireEmailOtp) ...[
          OtpVerifyRow(
            key: const ValueKey('portal-email-otp'),
            label: 'Email',
            verified: _emailOtpOk,
            onVerified: () {
              setState(() {
                _emailOtpOk = true;
                _fieldErrors.remove('emailOtp');
                _error = null;
              });
              _refreshValidation();
            },
            onSend: widget.onSendEmailOtp == null
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!_validateBeforeSendEmailOtp()) return false;
                    try {
                      final res = await widget.onSendEmailOtp!(_email.text.trim());
                      if (res['success'] == true) {
                        if (mounted) {
                          setState(() {
                            _fieldErrors.remove('emailOtp');
                            _error = null;
                          });
                        }
                        return true;
                      }
                      final err = res['error']?.toString() ?? 'Failed to send OTP';
                      if (mounted) {
                        setState(() => _error = err);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                      }
                      return false;
                    } catch (e) {
                      final err = e.toString().contains('TimeoutException')
                          ? 'Server timed out sending OTP. Check backend on port 8084 and try again.'
                          : 'Failed to send OTP: $e';
                      if (mounted) {
                        setState(() => _error = err);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                      }
                      return false;
                    }
                  },
            onVerify: widget.onVerifyEmailOtp == null
                ? null
                : (otp) async {
                    FocusScope.of(context).unfocus();
                    final code = otp.trim();
                    if (code.isEmpty) return 'Enter the OTP code';
                    if (code.length < 4 || code.length > 8) {
                      return 'Enter a valid OTP code';
                    }
                    try {
                      final res = await widget.onVerifyEmailOtp!(
                        email: _email.text.trim(),
                        otp: code,
                      );
                      if (res['success'] == true) return null;
                      return res['error']?.toString() ?? 'Invalid or expired OTP';
                    } catch (e) {
                      return e.toString().contains('TimeoutException')
                          ? 'Server timed out verifying OTP. Try again.'
                          : 'Verification failed: $e';
                    }
                  },
          ),
          _errorText('emailOtp'),
        ],
        const SizedBox(height: 8),
        ObscurePasswordField(
          controller: _password,
          label: 'Password *',
          showStrength: true,
          filled: true,
          prefixIcon: Icons.lock_outline,
          errorText: _fieldErrors['password'],
          onChanged: (_) => _refreshValidation(),
        ),
        const SizedBox(height: 8),
        ObscurePasswordField(
          controller: _confirmPassword,
          label: 'Confirm password *',
          filled: true,
          prefixIcon: Icons.lock_outline,
          errorText: _fieldErrors['confirmPassword'],
          onChanged: (_) => _refreshValidation(),
        ),
        if (widget.requirePhoneOtp) ...[
          OtpVerifyRow(
            label: 'Phone',
            verified: _phoneOtpOk,
            onVerified: () {
              setState(() => _phoneOtpOk = true);
              _refreshValidation();
            },
          ),
          _errorText('phoneOtp'),
        ],
        if (widget.requireTerms) ...[
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _terms,
            onChanged: (v) {
              setState(() => _terms = v ?? false);
              _refreshValidation();
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'I agree to the Terms & Conditions and Privacy Policy',
              style: TextStyle(fontSize: 13),
            ),
          ),
          _errorText('terms'),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _loading
                ? null
                : () {
                    setState(() {
                      _touched = true;
                      _fieldErrors
                        ..clear()
                        ..addAll(_computeFieldErrors());
                    });
                    if (_fieldErrors.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_fieldErrors.values.first)),
                      );
                      return;
                    }
                    _submit();
                  },
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit Registration'),
          ),
        ),
        if (!canSubmit && _touched)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Fix the highlighted fields above to enable registration.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _register = false;
                    _error = null;
                    _touched = false;
                    _fieldErrors.clear();
                  }),
          child: const Text('Already registered? Login'),
        ),
      ],
    );
  }
}
