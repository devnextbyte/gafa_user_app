import 'package:flutter/cupertino.dart';
import 'package:kio/connection/resp/hussain_err_resp.dart';

class HussainResp<Response> {
  final HussainErrResp error;
  final Response response;
  final int statusCode;

  HussainResp.fromSuccess({
    @required this.statusCode,
    @required this.response,
  }) : error = null;

  HussainResp.fromError({
    @required this.statusCode,
    @required this.error,
  }) : response = null;

  HussainResp.fromErrMsg(String message)
      : statusCode = 0,
        error = HussainErrResp.fromError(message),
        response = null;

  bool get hasError {
    return error != null;
  }

  bool get isSuccess {
    return error == null;
  }
}
