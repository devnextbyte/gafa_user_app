import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_param.dart';

class HussainConnectParam extends HussainParam {
  String userName;
  String password;
  String role;

  HussainConnectParam({
    @required this.userName,
    @required this.password,
    @required this.role,
  });

  @override
  toJson() {
    return {
      "grantType": "password",
      "grant_type": "password",
      "username": userName,
      "password": password,
      "scope": "openid email profile offline_access roles",
      "role": role,
    };
  }
}
