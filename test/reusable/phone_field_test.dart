import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';

void main() {
  final phone = TextEditingController();

  group("Phone Widget Test", () {
    testWidgets("Phone Field in scaffold test", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: Scaffold(body: PhoneField(controller: phone)),
      ));
      expect(find.text("Phone Number"), findsOneWidget);
      final afg = find.text("+92");
      expect(afg, findsNothing);
      await tester.tap(find.byKey(Key("flag_widget")));
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(afg, find.byKey(Key("flag_list")), Offset(0, -1000));
      await tester.tap(afg);
      await tester.pumpAndSettle();
      expect(afg, findsOneWidget);

      await tester.enterText(find.byKey(Key("phone_input")), "123456781");
      await tester.pumpAndSettle();
      expect(phone.text, "+92123456781");
    });

    testWidgets("Phone field validation test", (tester) async {
      final key = GlobalKey<FormState>();
      await tester.pumpWidget(GafaMoneyApp(
        home: Scaffold(
          body: Form(key: key, child: PhoneField(controller: phone)),
        ),
      ));
      final errorMessage = find.text("Invalid phone number");
      expect(errorMessage, findsNothing);

      key.currentState.validate();
      await tester.pumpAndSettle();

      expect(errorMessage, findsOneWidget);

      await tester.enterText(find.byKey(Key("phone_input")), "123454781");
      await tester.pumpAndSettle();

      expect(find.text("+221"), findsOneWidget);

      key.currentState.validate();
      await tester.pumpAndSettle();

      expect(errorMessage, findsNothing);
    });
  });
}
