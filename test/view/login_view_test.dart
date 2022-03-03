import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/auth/login_view.dart';

import '../snippets.dart';

void main() {
  group("Login View Test", () {
    testWidgets("Labels", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(home: LoginView()));
      expect(find.text("Phone Number"), findsOneWidget);
      expect(find.text("New to Gafa?"), findsOneWidget);
    });

    testWidgets("Flag Widget", (WidgetTester tester) async {
      await tester.pumpWidget(GafaMoneyApp(home: LoginView()));
      await testFlagChange(tester);
    });

    test("Phone Pass Validator", (){
      expect("Invalid phone number", validatePhone(null));
      expect("Invalid phone number", validatePhone(""));
      expect("Invalid phone number", validatePhone("12345"));
      expect(null, validatePhone("123456781"));

      expect("Please enter a 4 digit pin", validatePin(null));
      expect("Please enter a 4 digit pin", validatePin(""));
      expect("Please enter a 4 digit pin", validatePin("124"));
      expect(null, validatePin("1234"));
    });

    testWidgets("Pass validation", (tester) async{
      await tester.pumpWidget(GafaMoneyApp(home: LoginView()));
      final passErr = find.text("Please enter a 4 digit pin");

      expect(passErr, findsNothing);

      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(passErr, findsOneWidget);

      await tester.enterText(find.byKey(Key("pin")),"1234");
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(passErr, findsNothing);
    });

  });
}
