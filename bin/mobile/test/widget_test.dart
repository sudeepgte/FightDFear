import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/main.dart';
import 'package:fight_d_fear/screens/landing/landing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App opens on landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const FightDFearApp());
    await tester.pump();

    // Wait for auth bootstrap (avoid pumpAndSettle — landing SOS pulse repeats).
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byType(LandingScreen).evaluate().isNotEmpty) {
        break;
      }
    }

    expect(find.byType(LandingScreen), findsOneWidget);
    expect(find.textContaining('Fight'), findsWidgets);
  });
}
