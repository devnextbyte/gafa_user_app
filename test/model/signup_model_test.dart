import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:kio/kio.dart';

void main() {
  group("Signup model test", () {
    Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");

    final phoneNumber = "+923164764239";
    test("resgister", () async {
      final resp = await requestSignUp.send(
        parameters: SignUpParam(phoneNumber, "Kamran Bashir","",""),
        token: "dummy",
      );
      if (resp.hasError) {
        print(resp.error.errorMessage);
      } else {
        print("Run OTP test");
      }
    });

    test("Otp Test", () async {
      final resp = await requestVerifyOtp.send(
        parameters: VerifyOtpParam(
          phoneNumber,
          "1254",
        ),
        token: "dummy",
      );
      if (resp.hasError) {
        print(resp.error.errorMessage);
      } else {
        // print(resp.response.j.toString());
      }
    });
  });
}
