import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'registration_form_kit.dart';

/// Structured Bank & Payout details section for provider profiles.
/// Replaces legacy single-field bank inputs with structured, validated fields.
class BankDetailsSection extends StatefulWidget {
  const BankDetailsSection({
    super.key,
    required this.accountHolderController,
    required this.accountNumberController,
    required this.confirmAccountNumberController,
    required this.ifscController,
    required this.bankNameController,
    required this.branchNameController,
    required this.upiController,
    required this.accountType,
    required this.onAccountTypeChanged,
    this.sectionNumber = '9',
    this.title = 'Payout & Bank Details',
    this.onChanged,
    this.isRequired = false,
  });

  final TextEditingController accountHolderController;
  final TextEditingController accountNumberController;
  final TextEditingController confirmAccountNumberController;
  final TextEditingController ifscController;
  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final TextEditingController upiController;
  final String accountType;
  final ValueChanged<String> onAccountTypeChanged;
  final String sectionNumber;
  final String title;
  final VoidCallback? onChanged;
  final bool isRequired;

  /// Helper to mask account number for secure UI display (e.g. •••• •••• 1234).
  static String maskAccountNumber(String raw) {
    final clean = raw.replaceAll(RegExp(r'\s+'), '');
    if (clean.length <= 4) return clean;
    final last4 = clean.substring(clean.length - 4);
    return '•••• •••• $last4';
  }

  /// Builds backend payload supporting both structured fields and legacy composite string.
  static Map<String, dynamic> buildPayload({
    required String accountHolder,
    required String accountNumber,
    required String ifsc,
    required String bankName,
    required String branch,
    required String accountType,
    String? upiId,
  }) {
    final holder = accountHolder.trim();
    final acct = accountNumber.trim();
    final ifscCode = ifsc.trim().toUpperCase();
    final bName = bankName.trim();
    final bBranch = branch.trim();
    final upi = (upiId ?? '').trim();

    final parts = <String>[];
    if (holder.isNotEmpty) parts.add('Account Holder: $holder');
    if (bName.isNotEmpty) parts.add('Bank: $bName');
    if (acct.isNotEmpty) parts.add('A/C: $acct');
    if (ifscCode.isNotEmpty) parts.add('IFSC: $ifscCode');
    if (bBranch.isNotEmpty) parts.add('Branch: $bBranch');
    if (accountType.isNotEmpty) parts.add('Type: $accountType');

    final legacyCombined = parts.join(' | ');

    return {
      'bankAccountHolder': holder,
      'bankAccountNumber': acct,
      'bankIfsc': ifscCode,
      'bankName': bName,
      'bankBranch': bBranch,
      'accountType': accountType,
      'upiId': upi,
      'bankDetails': legacyCombined,
    };
  }

  /// Parses saved profile map into individual fields, with legacy format extraction.
  static void populateFromProfile({
    required Map<String, dynamic> profile,
    required TextEditingController accountHolderController,
    required TextEditingController accountNumberController,
    required TextEditingController confirmAccountNumberController,
    required TextEditingController ifscController,
    required TextEditingController bankNameController,
    required TextEditingController branchNameController,
    required TextEditingController upiController,
    required ValueChanged<String> setAccountType,
  }) {
    // 1. Direct structured keys
    final directHolder = profile['bankAccountHolder']?.toString() ?? '';
    final directAcct = profile['bankAccountNumber']?.toString() ?? '';
    final directIfsc = profile['bankIfsc']?.toString() ?? '';
    final directBank = profile['bankName']?.toString() ?? '';
    final directBranch = profile['bankBranch']?.toString() ?? '';
    final directType = profile['accountType']?.toString() ?? '';
    final directUpi = profile['upiId']?.toString() ?? '';

    if (directHolder.isNotEmpty) accountHolderController.text = directHolder;
    if (directAcct.isNotEmpty) {
      accountNumberController.text = directAcct;
      confirmAccountNumberController.text = directAcct;
    }
    if (directIfsc.isNotEmpty) ifscController.text = directIfsc;
    if (directBank.isNotEmpty) bankNameController.text = directBank;
    if (directBranch.isNotEmpty) branchNameController.text = directBranch;
    if (directType.isNotEmpty) setAccountType(directType);
    if (directUpi.isNotEmpty) upiController.text = directUpi;

    // 2. Legacy fallback parser if structured fields are empty
    final legacy = profile['bankDetails']?.toString() ?? '';
    if (accountNumberController.text.isEmpty && legacy.isNotEmpty) {
      final segments = legacy.split(RegExp(r'[|,\n]'));
      for (final rawSeg in segments) {
        final seg = rawSeg.trim();
        final lower = seg.toLowerCase();
        if (lower.startsWith('account holder:') || lower.startsWith('holder:')) {
          accountHolderController.text = seg.substring(seg.indexOf(':') + 1).trim();
        } else if (lower.startsWith('bank:') || lower.startsWith('bank name:')) {
          bankNameController.text = seg.substring(seg.indexOf(':') + 1).trim();
        } else if (lower.startsWith('a/c:') || lower.startsWith('account:') || lower.startsWith('account number:')) {
          final val = seg.substring(seg.indexOf(':') + 1).trim();
          accountNumberController.text = val;
          confirmAccountNumberController.text = val;
        } else if (lower.startsWith('ifsc:') || lower.startsWith('ifsc code:')) {
          ifscController.text = seg.substring(seg.indexOf(':') + 1).trim().toUpperCase();
        } else if (lower.startsWith('branch:') || lower.startsWith('branch name:')) {
          branchNameController.text = seg.substring(seg.indexOf(':') + 1).trim();
        } else if (lower.startsWith('type:')) {
          setAccountType(seg.substring(seg.indexOf(':') + 1).trim());
        }
      }
    }
  }

  @override
  State<BankDetailsSection> createState() => _BankDetailsSectionState();
}

class _BankDetailsSectionState extends State<BankDetailsSection> {
  static const _accountTypes = ['Savings', 'Current'];
  static const _majorBanks = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Punjab National Bank',
    'Bank of Baroda',
    'Canara Bank',
    'Union Bank of India',
    'IndusInd Bank',
    'Federal Bank',
    'Other Bank',
  ];

  String? _holderError;
  String? _accountError;
  String? _confirmError;
  String? _ifscError;
  String? _bankNameError;
  String? _branchError;
  String? _upiError;
  bool _obscureAccount = false;

  void _validate() {
    setState(() {
      final hasAnyBankInput = widget.accountHolderController.text.isNotEmpty ||
          widget.accountNumberController.text.isNotEmpty ||
          widget.ifscController.text.isNotEmpty ||
          widget.bankNameController.text.isNotEmpty ||
          widget.branchNameController.text.isNotEmpty;

      if (widget.isRequired || hasAnyBankInput) {
        _holderError = RegValidators.nameError(widget.accountHolderController.text, label: 'Account holder name');
        _accountError = RegValidators.accountNumberError(widget.accountNumberController.text);
        _confirmError = RegValidators.confirmAccountNumberError(
          widget.accountNumberController.text,
          widget.confirmAccountNumberController.text,
        );
        _ifscError = RegValidators.ifscError(widget.ifscController.text);
        _bankNameError = widget.bankNameController.text.trim().isEmpty ? 'Bank name is required' : null;
        _branchError = widget.branchNameController.text.trim().isEmpty ? 'Branch name is required' : null;
      } else {
        _holderError = null;
        _accountError = null;
        _confirmError = null;
        _ifscError = null;
        _bankNameError = null;
        _branchError = null;
      }

      _upiError = RegValidators.upiIdError(widget.upiController.text);
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.sectionNumber,
                style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFF43F5E)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // UPI ID
        TextFormField(
          key: const ValueKey('bank_upi_input'),
          controller: widget.upiController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'UPI ID (optional)',
            hintText: 'e.g. yourname@okhdfcbank',
            helperText: 'Enter your UPI ID (e.g., name@upi) for instant payouts.',
            helperMaxLines: 2,
            errorText: _upiError,
            prefixIcon: const Icon(Icons.qr_code_2_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Account Holder Name
        TextFormField(
          key: const ValueKey('bank_holder_input'),
          controller: widget.accountHolderController,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'Account Holder Name${widget.isRequired ? ' *' : ''}',
            hintText: 'As printed on your passbook or cheque',
            helperText: 'Enter the name registered with your bank.',
            helperMaxLines: 2,
            errorText: _holderError,
            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Bank Account Number
        TextFormField(
          key: const ValueKey('bank_account_number_input'),
          controller: widget.accountNumberController,
          keyboardType: TextInputType.number,
          obscureText: _obscureAccount,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'Bank Account Number${widget.isRequired ? ' *' : ''}',
            hintText: '9 to 18 digit account number',
            helperText: 'Enter your bank account number.',
            helperMaxLines: 2,
            errorText: _accountError,
            prefixIcon: const Icon(Icons.account_balance_outlined, color: Color(0xFFBE123C)),
            suffixIcon: IconButton(
              icon: Icon(_obscureAccount ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => setState(() => _obscureAccount = !_obscureAccount),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Confirm Bank Account Number
        TextFormField(
          key: const ValueKey('bank_confirm_account_number_input'),
          controller: widget.confirmAccountNumberController,
          keyboardType: TextInputType.number,
          obscureText: _obscureAccount,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'Confirm Bank Account Number${widget.isRequired ? ' *' : ''}',
            hintText: 'Re-enter account number',
            helperText: 'Re-enter your bank account number for confirmation.',
            helperMaxLines: 2,
            errorText: _confirmError,
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // IFSC Code
        TextFormField(
          key: const ValueKey('bank_ifsc_input'),
          controller: widget.ifscController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
          ],
          onChanged: (v) {
            final upper = v.toUpperCase();
            if (upper != v) {
              widget.ifscController.value = widget.ifscController.value.copyWith(
                text: upper,
                selection: TextSelection.collapsed(offset: upper.length),
              );
            }
            _validate();
          },
          decoration: InputDecoration(
            labelText: 'IFSC Code${widget.isRequired ? ' *' : ''}',
            hintText: 'e.g. HDFC0001234',
            helperText: 'Enter your bank\'s 11-character IFSC code.',
            helperMaxLines: 2,
            errorText: _ifscError,
            prefixIcon: const Icon(Icons.tag_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Bank Name (AutoComplete / Dropdown / Text)
        TextFormField(
          key: const ValueKey('bank_name_input'),
          controller: widget.bankNameController,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'Bank Name${widget.isRequired ? ' *' : ''}',
            hintText: 'e.g. State Bank of India',
            helperText: 'Enter or select your bank name.',
            helperMaxLines: 2,
            errorText: _bankNameError,
            prefixIcon: const Icon(Icons.business_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Branch Name
        TextFormField(
          key: const ValueKey('bank_branch_input'),
          controller: widget.branchNameController,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            labelText: 'Branch Name${widget.isRequired ? ' *' : ''}',
            hintText: 'e.g. Indiranagar, Bengaluru',
            helperText: 'Enter your bank branch name.',
            helperMaxLines: 2,
            errorText: _branchError,
            prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Account Type Dropdown
        DropdownButtonFormField<String>(
          key: const ValueKey('bank_account_type_input'),
          value: _accountTypes.contains(widget.accountType) ? widget.accountType : _accountTypes.first,
          decoration: InputDecoration(
            labelText: 'Account Type',
            helperText: 'Select your bank account type.',
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _accountTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (v) {
            if (v != null) {
              widget.onAccountTypeChanged(v);
              _validate();
            }
          },
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
