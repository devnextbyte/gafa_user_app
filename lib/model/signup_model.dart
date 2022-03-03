import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/hussain_param.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';
import 'package:kio/connection/resp/void_resp.dart';
import 'package:kio/external_enum.dart';

final requestSignUp = Hussain<SignUpParam, VoidResp>(
  respCreator: (json) => VoidResp.fromJson(json),
  route: "/api/v1/Registration",
  type: HussainType.POST,
);

final requestVerifyOtp = Hussain<VerifyOtpParam, VerifyOtpResp>(
  respCreator: (json) => VerifyOtpResp.fromJson(json),
  route: "/api/v1/Registration/verify",
  type: HussainType.POST,
);

final requestSetPassword = Hussain<SetPassParam, VoidResp>(
  respCreator: (json) => VoidResp.fromJson(json),
  route: "/api/v1/Registration/setPassword",
  type: HussainType.POST,
);

class SignUpParam extends HussainParam {
  final String phoneNumber;
  final String name;
  final String referralCode;
  final String dateOfBirth;

  SignUpParam(this.phoneNumber, this.name, this.referralCode,this.dateOfBirth);

  @override
  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "name": name,
        "referralCode": referralCode,
        "dateOfBirth": dateOfBirth,
      };
}

class VerifyOtpParam extends HussainParam {
  final String phoneNumber;
  final String otp;

  VerifyOtpParam(this.phoneNumber, this.otp);

  @override
  Map<String, dynamic> toJson() => {"phoneNumber": phoneNumber, "otp": otp};
}

class VerifyOtpResp extends HussainOkResp {
  String token;
  String id;

  VerifyOtpResp.fromJson(json)
      : token = json['token'] is String
            ? json['token']
            : json['token'] != ""
                ? json['token']['result']
                : "",
        id = json['Id'] ?? "",
        super.fromJson(json);
}

class SetPassParam extends HussainParam {
  final String email;
  final String pin;
  final String token;
  final String userId;

  SetPassParam(this.email, this.pin, this.token, this.userId);

  @override
  Map<String, dynamic> toJson() =>
      {"email": email, "pin": pin, "token": token, "userId": userId};
}
