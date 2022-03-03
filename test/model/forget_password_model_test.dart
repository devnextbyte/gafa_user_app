import 'package:gafamoney/model/forget_pass_model.dart';
import 'package:kio/connection/hussain.dart';
import 'package:test/test.dart';

void main() {
  final fpr = ForgetPassReq();
  Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");
  final pn = "+221123456786";
  var token = "";
  var userId = "";

  group("Forget Password", () {
    test("Model", () {
      final fpp = ForgetPasswordParam(mobileNumber: pn);
      final json = fpp.toJson();
      expect(json['mobileNumber'], pn);
    });

    group("Requests", () {
      test("Correct phone", () async {
        final resp = await fpr.requestForgetPass(pn);
        expect(resp.isSuccess, true);
      });

      test("Invalid phone", () async {
        final resp = await fpr.requestForgetPass("+923021");
        expect(resp.hasError, true);
        expect(resp.error.errorMessage.contains("Validation failed"), true);
      });

      test("Unregistered user phone", () async {
        final resp = await fpr.requestForgetPass("+923028897458");
        expect(resp.isSuccess, true);
      });
    });
  });

  group("VerifyOtp OTP", () {
    test("Model", () {
      final valOtp = ForgetPassVerifyOtp(
        mobileNumber: pn,
        otp: "1234",
      );
      final json = valOtp.toJson();
      expect(json["mobileNumber"], pn);
      expect(json["otp"], "1234");
    });

    group("Api tests", () {
      test("Send Request", () async {
        final resp = await fpr.requestForgetPass(pn);
        expect(resp.isSuccess, true);
      });

      test("Invalid OTP", () async {
        final resp = await fpr.requestForgetPassVerify(pn, "1234");
        expect(resp.hasError, true);
        print(resp.error.errorMessage);
      });
      test("Unregistered user", () async {
        final resp = await fpr.requestForgetPassVerify("+2218965247", "0000");
        expect(resp.hasError, false);
        expect(resp.response.token, "");
        expect(resp.response.id, "");
      });
      test("Valid OTP", () async {
        final resp = await fpr.requestForgetPassVerify(pn, "0000");
        expect(resp.isSuccess, true);
        print(resp.response.json);
        userId = resp.response.id;
        token = resp.response.token;
      });
    });
  });

  group("Change Password", () {
    test("Success test", () async {
      final resp = await fpr.requestNewPass(token, userId, "1111");
      expect(resp.isSuccess, true);
    });

    test("Error tests", () async {
      final resp =
          await fpr.requestNewPass("invalidToken", "invalidUserId", "1111");
      expect(resp.isSuccess, false);
      expect(resp.error.errorMessage.contains("Resource was not found"), true);
    });
  });
}
