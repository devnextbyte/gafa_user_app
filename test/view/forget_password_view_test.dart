import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/state/forget_password_state.dart';
import 'package:gafamoney/view/auth/enter_otp.dart';
import 'package:gafamoney/view/auth/forget_password_view.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockForgetPasswordState extends Mock implements ForgetPasswordState {}

void main() {
  group("Forget Password ", () {
    final sendOtpBtn = find.widgetWithText(ElevatedButton, "Send OTP");
    testWidgets("labels", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: ForgetPasswordView(),
      ));
      expect(find.text("We understand you forgot your password 🤗"),
          findsOneWidget);
      final phone = find.byType(PhoneField);
      expect(phone, findsOneWidget);
      expect(find.ancestor(of: phone, matching: find.byType(Scaffold)),
          findsOneWidget);
      expect(sendOtpBtn, findsOneWidget);
    });

    testWidgets("Loading state", (tester) async {
      await tester.pumpWidget(GafaMoneyApp(
        home: ChangeNotifierProvider(
            create: (_) => ForgetPasswordState()..loading = true,
            child: ForgetPasswordViewBody()),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(sendOtpBtn, findsNothing);
    });

    group("Send OTP behavior", () {
      final mockFps = MockForgetPasswordState();
      when(mockFps.loading).thenReturn(false);
      final openTestWidget = (tester) => tester.pumpWidget(GafaMoneyApp(
            home: ChangeNotifierProvider<ForgetPasswordState>.value(
              value: mockFps,
              child: ForgetPasswordViewBody(),
            ),
          ));

      final Future Function(WidgetTester) enterPhoneAndGo = (tester) async {
        await tester.enterText(find.byKey(Key("phone_input")), "123456781");
        await tester.tap(sendOtpBtn);
        await tester.pumpAndSettle();
      };

      testWidgets("Send OTP returns error", (tester) async {
        final errStr = "Error from server";
        when(mockFps.sendRequest("+221123456781"))
            .thenAnswer((realInvocation) async => errStr);
        await openTestWidget(tester);
        expect(find.text(errStr), findsNothing);
        await enterPhoneAndGo(tester);
        expect(find.text(errStr), findsOneWidget);
      });

      testWidgets("Send OTP success", (tester) async {
        when(mockFps.sendRequest("+221123456781"))
            .thenAnswer((realInvocation) async => null);
        await openTestWidget(tester);
        await enterPhoneAndGo(tester);
        expect(find.byType(EnterOtpView), findsOneWidget);
      });

    });
  });
}
