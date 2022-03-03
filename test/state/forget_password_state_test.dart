import 'package:gafamoney/state/forget_password_state.dart';
import 'package:kio/kio.dart';
import 'package:test/test.dart';

void main() {
  Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");

  group("Forget Password State", () {
    test("Send request, correct phone", () async {
      final fp = ForgetPasswordState();
      final resp = await fp.sendRequest("+923024191873");
      expect(resp, null);
    });

    test("Send request, wrong", () async {
      final fp = ForgetPasswordState();
      var resp = await fp.sendRequest("+9230088");
      expect(resp, "Invalid phone number");

      resp = await fp.sendRequest(null);
      expect(resp, "Invalid phone number");
    });
  });
}
