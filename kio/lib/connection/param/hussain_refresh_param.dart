import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_param.dart';

class HussainRefreshParam extends HussainParam {
  String refreshToken;

  HussainRefreshParam({
    @required this.refreshToken,
  });

  @override
  toJson() {
    return {
      'grantType': 'refresh_token',
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      "scope": "openid email profile offline_access roles",
    };
  }


}
