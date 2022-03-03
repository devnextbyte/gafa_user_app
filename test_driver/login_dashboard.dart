import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Login and view dashboard", () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Login", ()async{
      await driver.waitFor(find.byType("LoginView"));
      await driver.tap(find.byValueKey("phone_input"));
      await driver.enterText("123456786");
      await driver.tap(find.byValueKey("pin"));
      await driver.enterText("1234");
      await driver.tap(find.text("Login"));
      await driver.runUnsynchronized(() async =>
      await driver.waitFor(find.byType("CircularProgressIndicator")));
      await driver.waitFor(find.byType("Home"));
      await driver.waitFor(find.byType("Dashboard"));
    });


  });
}
