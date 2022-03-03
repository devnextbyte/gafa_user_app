import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/model/forget_pass_model.dart';
import 'package:gafamoney/view/auth/new_password_view.dart';
import 'package:gafamoney/view/reusable/password_field.dart';
import 'package:kio/connection/resp/hussain_err_resp.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:kio/kio.dart';
import 'package:mockito/mockito.dart';

class MockForgetPassReq extends Mock implements ForgetPassReq {}

void main() {
  group("Enter New Password View Tests", () {
    final cngPassBtn = find.widgetWithText(ElevatedButton, "Change Password");
    final passErr = find.text("Please enter a 4 digit pin");
    final cnfrmErr = find.text("Confirm pin does not match with new pin");
    final loader = find.byType(CircularProgressIndicator);
    final serverErr = find.text("Error from server\n");
    final newPinField = find.widgetWithText(PasswordField, "New Pin");
    final confirmField = find.widgetWithText(PasswordField, "Confirm Pin");

    final fpr = MockForgetPassReq();
    when(fpr.requestNewPass("dummy", "dummy", "1234")).thenAnswer(
      (realInvocation) async => HussainResp.fromError(
          statusCode: 400,
          error: HussainErrResp.fromJson({"message": "Error from server"})),
    );
    when(fpr.requestNewPass("dummy", "dummy", "1111")).thenAnswer(
      (realInvocation) async => HussainResp.fromSuccess(
          statusCode: 400, response: VoidResp.fromJson({})),
    );

    testWidgets("Validation", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: NewPasswordView(
          token: "dummy",
          userId: "dummy",
        ),
      ));
      expect(loader, findsNothing);
      await tester.tap(cngPassBtn);
      await tester.pumpAndSettle();
      expect(passErr, findsOneWidget);
      expect(cnfrmErr, findsNothing);
      await tester.enterText(newPinField, "1234");
      await tester.tap(cngPassBtn);
      await tester.pumpAndSettle();
      expect(cnfrmErr, findsOneWidget);
    });

    testWidgets("Test Loading State", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: NewPasswordView(
          loading: true,
          userId: "dummy",
          token: "dummy",
        ),
      ));
      expect(loader, findsOneWidget);
      expect(cngPassBtn, findsNothing);
    });

    testWidgets("Handle error form server", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
          home: NewPasswordView(token: "dummy", userId: "dummy", line: fpr)));
      await tester.enterText(newPinField, "1234");
      await tester.enterText(confirmField, "1234");
      await tester.tap(cngPassBtn);
      await tester.pumpAndSettle();
      expect(serverErr, findsOneWidget);
    });
  });
}
