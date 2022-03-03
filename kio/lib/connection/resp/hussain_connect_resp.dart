import 'dart:convert';

import 'package:kio/connection/resp/hussain_ok_resp.dart';

class HussainConnectResp<R extends HussainOkResp> extends HussainOkResp {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> idToken;
  final int exipresIn;

  HussainConnectResp.fromJson(json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        idToken = _parseJwtPayLoad(json['id_token']),
        exipresIn = json['expires_in'],
        super.fromJson(json);

  static Map<String, dynamic> _parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    (payloadMap as Map<String, dynamic>).addAll(_parseJwtHeader(token));
    return payloadMap;
  }

  static Map<String, dynamic> _parseJwtHeader(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[0]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }


}
