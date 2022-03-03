import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/view/auth/signup_view.dart';
import 'package:flutter/material.dart';

extension FinderExtension on CommonFinders {
  Finder inputField(String label) {
    return find.ancestor(
        of: find.text(label), matching: find.byType(TextField));
  }

  Finder inputFormField(String label) {
    return find.ancestor(
        of: find.text(label), matching: find.byType(TextFormField));
  }
}

void main() {
  group("SignUp View Test", () {
    final signUpButton = find.text("Sign Up");
    final err = find.text("This field is mandatory");
    final errPhn = find.text("Invalid phone number");
    testWidgets("First and last name validator", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(home: SignUpView()));
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(err, findsNWidgets(2));
      expect(errPhn, findsOneWidget);

      await tester.enterText(find.byKey(Key("phone_input")), "123456781");

      await tester.enterText(
        find.inputFormField("First Name"),
        "Kamran",
      );
      await tester.enterText(
        find.inputFormField("Last Name"),
        "Bashir",
      );
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(err, findsNothing);
    });
  });
}
