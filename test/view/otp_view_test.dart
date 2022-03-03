import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/model/forget_pass_model.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:gafamoney/view/auth/enter_otp.dart';
import 'package:gafamoney/view/auth/new_password_view.dart';
import 'package:kio/connection/resp/hussain_err_resp.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:mockito/mockito.dart';

class MockForgetPassReq extends Mock implements ForgetPassReq {}

void main() {
  group("Enter OTP View Test", () {
    final progress = find.byType(CircularProgressIndicator);
    final activateBtn = find.widgetWithText(ElevatedButton, "Activate Account");
    final otpValidErr = find.text("Enter OTP Please");
    final otpBoxes = find.byType(TextField);
    final pn = "+221123456781";

    final fpr = MockForgetPassReq();
    when(fpr.requestForgetPassVerify(pn, "0000"))
        .thenAnswer((realInvocation) async {
      return HussainResp.fromSuccess(
          statusCode: 200,
          response: VerifyOtpResp.fromJson({"token": "dummy", "id": "dummy"}));
    });
    when(fpr.requestForgetPassVerify(pn, "4321"))
        .thenAnswer((realInvocation) async {
      return HussainResp.fromError(
          statusCode: 0,
          error: HussainErrResp.fromJson({"message": "Invalid OTP"}));
    });

    testWidgets("Empty Validation", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
          home: EnterOtpView(
        forgetPassFlow: true,
        phoneNumber: "+221123456781",
      )));
      expect(otpValidErr, findsNothing);
      await tester.tap(activateBtn);
      await tester.pumpAndSettle();
      expect(otpValidErr, findsOneWidget);
      expect(progress, findsNothing);
    });

    testWidgets("Incomplete Validation", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
          home: EnterOtpView(
        phoneNumber: "+221123456781",
        forgetPassFlow: true,
      )));
      expect(otpValidErr, findsNothing);
      await tester.enterText(otpBoxes.at(0), "0");
      await tester.enterText(otpBoxes.at(1), "0");
      await tester.enterText(otpBoxes.at(2), "0");
      await tester.tap(activateBtn);
      await tester.pumpAndSettle();
      expect(otpValidErr, findsOneWidget);
    });

    testWidgets(("Loading state"), (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
          home: EnterOtpView(
        phoneNumber: "+221123456781",
        forgetPassFlow: true,
        loading: true,
      )));
      expect(progress, findsOneWidget);
    });

    testWidgets("Invalid OTP", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: EnterOtpView(
          phoneNumber: pn,
          request: fpr,
          forgetPassFlow: true,
        ),
      ));
      await tester.enterText(otpBoxes.at(0), "4");
      await tester.enterText(otpBoxes.at(1), "3");
      await tester.enterText(otpBoxes.at(2), "2");
      await tester.enterText(otpBoxes.at(3), "1");
      await tester.tap(activateBtn);
      await tester.pumpAndSettle();
      expect(find.text("Invalid OTP\n"), findsOneWidget);
    });

    testWidgets("Valid OTP", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: EnterOtpView(
          phoneNumber: pn,
          request: fpr,
          forgetPassFlow: true,
        ),
      ));
      expect(find.byType(NewPasswordView), findsNothing);
      await tester.enterText(otpBoxes.at(0), "0");
      await tester.enterText(otpBoxes.at(1), "0");
      await tester.enterText(otpBoxes.at(2), "0");
      await tester.enterText(otpBoxes.at(3), "0");
      await tester.tap(activateBtn);
      await tester.pumpAndSettle();
      expect(find.byType(NewPasswordView), findsOneWidget);
    });
  });
}
