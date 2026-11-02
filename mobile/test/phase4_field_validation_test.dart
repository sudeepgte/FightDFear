import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/widgets/registration_form_kit.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

void main() {
  group('Phase 4: Field Validation Tests', () {
    test('nameError validates name inputs correctly', () {
      expect(RegValidators.nameError(''), isNotNull);
      expect(RegValidators.nameError('   '), isNotNull);
      expect(RegValidators.nameError('A'), isNotNull);
      expect(RegValidators.nameError('John123'), isNotNull);
      expect(RegValidators.nameError('Jane Doe'), isNull);
      expect(RegValidators.nameError("Dr. Mary O'Connor"), isNull);
    });

    test('emailError validates email inputs correctly', () {
      expect(RegValidators.emailError(''), isNotNull);
      expect(RegValidators.emailError('invalid-email'), isNotNull);
      expect(RegValidators.emailError('user@'), isNotNull);
      expect(RegValidators.emailError('@domain.com'), isNotNull);
      expect(RegValidators.emailError('user@domain'), isNotNull);
      expect(RegValidators.emailError('test.user@fightdfear.in'), isNull);
    });

    test('phoneError validates 10-digit mobile numbers', () {
      expect(RegValidators.phoneError(''), isNotNull);
      expect(RegValidators.phoneError('12345'), isNotNull);
      expect(RegValidators.phoneError('12345678901'), isNotNull);
      expect(RegValidators.phoneError('abcdefghij'), isNotNull);
      expect(RegValidators.phoneError('9876543210'), isNull);
      expect(RegValidators.phoneError('8765432109'), isNull);
    });

    test('ifscError validates Indian Financial System Code format', () {
      expect(RegValidators.ifscError(''), isNotNull);
      expect(RegValidators.ifscError('HDFC'), isNotNull);
      expect(RegValidators.ifscError('HDFC1234567'), isNotNull); // 5th char must be 0
      expect(RegValidators.ifscError('HDFC0001234'), isNull);
      expect(RegValidators.ifscError('SBIN0000456'), isNull);
      expect(RegValidators.ifscError('icic0001234'), isNull); // case-insensitive check
    });

    test('accountNumberError validates bank account digits', () {
      expect(RegValidators.accountNumberError(''), isNotNull);
      expect(RegValidators.accountNumberError('12345'), isNotNull); // < 9 digits
      expect(RegValidators.accountNumberError('12345678901234567890'), isNotNull); // > 18 digits
      expect(RegValidators.accountNumberError('12345ABCD'), isNotNull);
      expect(RegValidators.accountNumberError('123456789'), isNull);
      expect(RegValidators.accountNumberError('50100234567890'), isNull);
    });

    test('confirmAccountNumberError checks account number match', () {
      expect(RegValidators.confirmAccountNumberError('123456789', '987654321'), isNotNull);
      expect(RegValidators.confirmAccountNumberError('123456789', '123456789'), isNull);
      expect(RegValidators.confirmAccountNumberError(' 123456789 ', '123456789'), isNull);
    });

    test('upiIdError validates UPI handle format', () {
      expect(RegValidators.upiIdError('invalid'), isNotNull);
      expect(RegValidators.upiIdError('user@'), isNotNull);
      expect(RegValidators.upiIdError('@okhdfcbank'), isNotNull);
      expect(RegValidators.upiIdError(''), isNull); // optional when empty
      expect(RegValidators.upiIdError('', required: true), isNotNull);
      expect(RegValidators.upiIdError('name@upi'), isNull);
      expect(RegValidators.upiIdError('9876543210@paytm'), isNull);
    });

    test('pincodeError validates 6-digit Indian PIN codes', () {
      expect(RegValidators.pincodeError(''), isNotNull);
      expect(RegValidators.pincodeError('12345'), isNotNull);
      expect(RegValidators.pincodeError('1234567'), isNotNull);
      expect(RegValidators.pincodeError('012345'), isNotNull); // cannot start with 0
      expect(RegValidators.pincodeError('110001'), isNull);
      expect(RegValidators.pincodeError('560001'), isNull);
    });

    test('experienceError validates years of experience', () {
      expect(RegValidators.experienceError('-1'), isNotNull);
      expect(RegValidators.experienceError('abc'), isNotNull);
      expect(RegValidators.experienceError('75'), isNotNull); // > 60
      expect(RegValidators.experienceError('0'), isNull);
      expect(RegValidators.experienceError('5'), isNull);
      expect(RegValidators.experienceError('30'), isNull);
    });

    test('ProfileFieldHelper generates contextual helper messages', () {
      final nameHelper = ProfileFieldHelper.instructionForField(label: 'Full Name', required: true);
      expect(nameHelper.toLowerCase(), contains('name'));

      final phoneHelper = ProfileFieldHelper.instructionForField(label: 'Phone Number', required: true);
      expect(phoneHelper.toLowerCase(), contains('10-digit'));

      final ifscHelper = ProfileFieldHelper.instructionForField(label: 'IFSC Code');
      expect(ifscHelper.toLowerCase(), contains('official'));

      final upiHelper = ProfileFieldHelper.instructionForField(label: 'UPI ID');
      expect(upiHelper.toLowerCase(), contains('upi'));
    });
  });
}
