import 'package:flutter/foundation.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/hussain_param.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:kio/connection/resp/void_resp.dart';
import 'package:kio/external_enum.dart';

class ForgetPassReq {
  Hussain<ForgetPasswordParam, VoidResp> get _requestForgetPassH =>
      Hussain<ForgetPasswordParam, VoidResp>(
        respCreator: (json) => VoidResp.fromJson(json),
        route: "/api/v1/User/forgetPassword",
        type: HussainType.POST,
      );

  Hussain<ForgetPassVerifyOtp, VerifyOtpResp> get _requestPassVerify =>
      Hussain<ForgetPassVerifyOtp, VerifyOtpResp>(
        type: HussainType.POST,
        route: "/api/v1/User/verifyOtpPin",
        respCreator: (json) => VerifyOtpResp.fromJson(json),
      );

  Hussain<NewPassParam, VoidResp> get _requestNewPass =>
      Hussain<NewPassParam, VoidResp>(
        type: HussainType.PUT,
        route: "/api/v1/Registration/setPasswordByToken",
        respCreator: (json) => VoidResp.fromJson(json),
      );

  Future<HussainResp<VerifyOtpResp>> requestForgetPassVerify(
      String mobileNumber, String otp) async {
    return _requestPassVerify.send(
        parameters: ForgetPassVerifyOtp(mobileNumber: mobileNumber, otp: otp),
        token: "dummy");
  }

  Future<HussainResp<VoidResp>> requestForgetPass(String mobileNumber) async {
    return _requestForgetPassH.send(
        parameters: ForgetPasswordParam(mobileNumber: mobileNumber),
        token: "dummy");
  }

  Future<HussainResp<VoidResp>> requestNewPass(
      String token, String userId, String pin) {
    return _requestNewPass.send(
        parameters: NewPassParam(pin, token, userId), token: "Dummy");
  }
}

class ForgetPassVerifyOtp extends HussainParam {
  final String mobileNumber;
  final String otp;

  ForgetPassVerifyOtp({@required this.mobileNumber, @required this.otp});

  @override
  Map<String, dynamic> toJson() => {
        "mobileNumber": mobileNumber,
        "otp": otp,
      };
}

class ForgetPasswordParam extends HussainParam {
  final String mobileNumber;

  ForgetPasswordParam({@required this.mobileNumber});

  @override
  Map<String, dynamic> toJson() => {"mobileNumber": mobileNumber};
}

class NewPassParam extends HussainParam {
  final String pin;
  final String token;
  final String userId;

  NewPassParam(this.pin, this.token, this.userId);

  @override
  Map<String, dynamic> toJson() =>
      {"pin": pin, "token": token, "userId": userId};
}
