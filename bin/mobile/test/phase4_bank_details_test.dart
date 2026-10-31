import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/widgets/bank_details_form.dart';

void main() {
  group('Phase 4: Structured Bank Details Tests', () {
    test('maskAccountNumber masks all but last 4 digits', () {
      expect(BankDetailsSection.maskAccountNumber(''), equals(''));
      expect(BankDetailsSection.maskAccountNumber('123'), equals('123'));
      expect(BankDetailsSection.maskAccountNumber('1234'), equals('1234'));
      expect(BankDetailsSection.maskAccountNumber('123456789012'), equals('•••• •••• 9012'));
      expect(BankDetailsSection.maskAccountNumber('  5010 0234 5678 90  '), equals('•••• •••• 7890'));
    });

    test('buildPayload produces structured keys and backward-compatible composite string', () {
      final payload = BankDetailsSection.buildPayload(
        accountHolder: 'Dr. Jane Smith',
        accountNumber: '50100234567890',
        ifsc: 'HDFC0001234',
        bankName: 'HDFC Bank',
        branch: 'Indiranagar',
        accountType: 'Current',
        upiId: 'drjane@okhdfcbank',
      );

      // Structured keys
      expect(payload['bankAccountHolder'], equals('Dr. Jane Smith'));
      expect(payload['bankAccountNumber'], equals('50100234567890'));
      expect(payload['bankIfsc'], equals('HDFC0001234'));
      expect(payload['bankName'], equals('HDFC Bank'));
      expect(payload['bankBranch'], equals('Indiranagar'));
      expect(payload['accountType'], equals('Current'));
      expect(payload['upiId'], equals('drjane@okhdfcbank'));

      // Composite string fallback
      final composite = payload['bankDetails'] as String;
      expect(composite, contains('Account Holder: Dr. Jane Smith'));
      expect(composite, contains('Bank: HDFC Bank'));
      expect(composite, contains('A/C: 50100234567890'));
      expect(composite, contains('IFSC: HDFC0001234'));
      expect(composite, contains('Branch: Indiranagar'));
      expect(composite, contains('Type: Current'));
    });

    testWidgets('populateFromProfile parses structured fields directly', (tester) async {
      final holder = TextEditingController();
      final numCtrl = TextEditingController();
      final confirm = TextEditingController();
      final ifsc = TextEditingController();
      final bName = TextEditingController();
      final branch = TextEditingController();
      final upi = TextEditingController();
      String accountType = 'Savings';

      final profileData = {
        'bankAccountHolder': 'Ananya Rao',
        'bankAccountNumber': '987654321098',
        'bankIfsc': 'SBIN0000456',
        'bankName': 'State Bank of India',
        'bankBranch': 'MG Road',
        'accountType': 'Current',
        'upiId': 'ananya@upi',
      };

      BankDetailsSection.populateFromProfile(
        profile: profileData,
        accountHolderController: holder,
        accountNumberController: numCtrl,
        confirmAccountNumberController: confirm,
        ifscController: ifsc,
        bankNameController: bName,
        branchNameController: branch,
        upiController: upi,
        setAccountType: (t) => accountType = t,
      );

      expect(holder.text, equals('Ananya Rao'));
      expect(numCtrl.text, equals('987654321098'));
      expect(confirm.text, equals('987654321098'));
      expect(ifsc.text, equals('SBIN0000456'));
      expect(bName.text, equals('State Bank of India'));
      expect(branch.text, equals('MG Road'));
      expect(upi.text, equals('ananya@upi'));
      expect(accountType, equals('Current'));
    });

    testWidgets('populateFromProfile falls back to composite bankDetails string', (tester) async {
      final holder = TextEditingController();
      final numCtrl = TextEditingController();
      final confirm = TextEditingController();
      final ifsc = TextEditingController();
      final bName = TextEditingController();
      final branch = TextEditingController();
      final upi = TextEditingController();
      String accountType = 'Savings';

      final legacyProfile = {
        'bankDetails': 'Account Holder: Priya Sharma, Bank: ICICI Bank, A/C: 112233445566, IFSC: ICIC0001234, Branch: Koramangala',
        'upiId': 'priya@icici',
      };

      BankDetailsSection.populateFromProfile(
        profile: legacyProfile,
        accountHolderController: holder,
        accountNumberController: numCtrl,
        confirmAccountNumberController: confirm,
        ifscController: ifsc,
        bankNameController: bName,
        branchNameController: branch,
        upiController: upi,
        setAccountType: (t) => accountType = t,
      );

      expect(holder.text, equals('Priya Sharma'));
      expect(bName.text, equals('ICICI Bank'));
      expect(numCtrl.text, equals('112233445566'));
      expect(confirm.text, equals('112233445566'));
      expect(ifsc.text, equals('ICIC0001234'));
      expect(branch.text, equals('Koramangala'));
      expect(upi.text, equals('priya@icici'));
    });
  });
}
