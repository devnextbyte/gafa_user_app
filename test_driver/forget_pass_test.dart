import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Forget Password Flow", () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    group("Forget Password", () {
      test("Enter phone and send", () async {
        await driver.waitFor(find.byValueKey("splash_screen"));
        await driver.waitFor(find.byValueKey("login_screen"));
        await driver.tap(find.text("Forget Password ?"));
        await driver.tap(find.byValueKey("phone_input"));
        //also test with invalid number
        await driver.enterText("123456781");
        await driver.tap(find.text("Send OTP"));
        await driver.runUnsynchronized(() async =>
        await driver.waitFor(find.byType("CircularProgressIndicator")));
        await driver.waitFor(find.byValueKey("EnterOtpView"));
      });

      test("Enter OTP and confirm", () async {
        await driver.tap(find.byValueKey("otpOne"));
        await driver.enterText("0");
        await driver.enterText("0");
        await driver.enterText("0");
        await driver.enterText("0");
        await driver.tap(find.text("Activate Account"));
        await driver.runUnsynchronized(() async =>
        await driver.waitFor(find.byType("CircularProgressIndicator")));
        await driver.waitFor(find.byType("NewPasswordView"));
        await driver.tap(find.text("New Pin"));
        await driver.enterText("1111");
        await driver.tap(find.text("Confirm Pin"));
        await driver.enterText("1111");
        await driver.tap(find.text("Change Password"));
        await driver.runUnsynchronized(() async =>
        await driver.waitFor(find.byType("CircularProgressIndicator")));
        await driver.waitFor(find.byType("LoginView"));
      });
    });
  });
}