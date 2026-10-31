import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/widgets/registration_form_kit.dart';

void main() {
  testWidgets('Send OTP shows loading, calls onSend, reveals OTP on success', (tester) async {
    var sendCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpVerifyRow(
            label: 'Email',
            verified: false,
            onVerified: () {},
            onSend: () async {
              sendCalls++;
              await Future<void>.delayed(const Duration(milliseconds: 50));
              return true;
            },
            onVerify: (_) async => null,
          ),
        ),
      ),
    );

    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Enter OTP'), findsNothing);

    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(find.text('Sending OTP…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpAndSettle();

    expect(sendCalls, 1);
    expect(find.text('Resend OTP'), findsOneWidget);
    expect(find.text('Enter OTP'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);
  });

  testWidgets('Send OTP failure does not reveal OTP field and clears loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpVerifyRow(
            label: 'Email',
            verified: false,
            onVerified: () {},
            onSend: () async => false,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Enter OTP'), findsNothing);
    expect(find.text('Sending OTP…'), findsNothing);
  });

  testWidgets('Rapid Send OTP taps only invoke one in-flight request', (tester) async {
    var sendCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpVerifyRow(
            label: 'Email',
            verified: false,
            onVerified: () {},
            onSend: () async {
              sendCalls++;
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.tap(find.text('Sending OTP…'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();

    expect(sendCalls, 1);
  });
}
