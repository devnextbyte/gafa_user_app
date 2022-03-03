import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:kio/connection/resp/void_resp.dart';

import 'resp/hussain_err_resp.dart';

const String _kioUrl = "https://api.gafapay.nextbytesolutions.com/";

enum _KioType { POST, PUT, GET, DELETE }

Future<HussainResp<T>> post<T>({
  @required String path,
  T Function(dynamic) respGen,
  Map<String, dynamic> Function() bodyParam,
  List<dynamic> pathParam = const [],
  String token = "dummy",
}) {
  return _request(
    type: _KioType.POST,
    respGen: respGen,
    path: path,
    bodyParam: bodyParam,
    pathParam: pathParam,
    token: token,
  );
}

Future<HussainResp<T>> put<T>({
  @required String path,
  T Function(dynamic) respGen,
  Map<String, dynamic> Function() bodyParam,
  List<dynamic> pathParam = const [],
  String token = "dummy",
}) {
  return _request(
    type: _KioType.PUT,
    respGen: respGen,
    path: path,
    bodyParam: bodyParam,
    pathParam: pathParam,
    token: token,
  );
}

Future<HussainResp<T>> delete<T>({
  @required String path,
  T Function(dynamic) respGen,
  Map<String, dynamic> Function() bodyParam,
  List<dynamic> pathParam = const [],
  String token = "dummy",
}) {
  return _request(
    type: _KioType.DELETE,
    respGen: respGen,
    path: path,
    bodyParam: bodyParam,
    pathParam: pathParam,
    token: token,
  );
}

Future<HussainResp<T>> get<T>({
  @required String path,
  T Function(dynamic) respGen,
  Map<String, dynamic> Function() bodyParam,
  List<dynamic> pathParam = const [],
  String token = "dummy",
}) {
  return _request(
    type: _KioType.GET,
    respGen: respGen,
    path: path,
    bodyParam: bodyParam,
    pathParam: pathParam,
    token: token,
  );
}

Future<HussainResp<T>> _request<T>({
  @required _KioType type,
  @required String path,
  T Function(dynamic) respGen,
  Map<String, dynamic> Function() bodyParam,
  List<dynamic> pathParam = const [],
  String token = "dummy",
}) async {
  Map<String, dynamic> param;
  Response<dynamic> dioResp;
  HussainResp<T> resp;
  final url = prefixBase(onUrl: path, param: pathParam);
  try {
    param = bodyParam != null ? bodyParam() : {};
  } catch (error) {
    return _handleParamErr(error);
  }
  print("Calling $url");
  print("With param $param");

  try {
    switch (type) {
      case _KioType.POST:
        dioResp = await _dio(token).post(url, data: param);
        break;
      case _KioType.PUT:
        dioResp = await _dio(token).put(url, data: param);
        break;
      case _KioType.GET:
        dioResp = await _dio(token).get(url, queryParameters: param);
        break;
      case _KioType.DELETE:
        dioResp = await _dio(token).get(url, queryParameters: param);
        break;
    }
  } catch (error) {
    return _handleDioErr<T>(error);
  }

  try {
    resp = HussainResp<T>.fromSuccess(
      statusCode: dioResp.statusCode,
      response: respGen == null ? VoidResp : respGen(dioResp.data),
    );
  } catch (error) {
    return _handleDioErr(error);
  }

  return resp;
}

// Options _options({bytes = false}) => Options(
//       responseType: bytes ? ResponseType.bytes : ResponseType.json,
//       contentType: ContentType.parse("application/json").toString(),
//     );

HussainResp _handleParamErr(error) {
  if (error is ArgumentError) {
    return HussainResp.fromErrMsg(
      "Invalid parameters: ${error.name} ${error.message}",
    );
  } else {
    return HussainResp.fromErrMsg("Invalid parameters");
  }
}

HussainResp<T> _handleDioErr<T>(error) {
  if (error is DioError) {
    print(error.type);
    if (error.response != null) {
      print(error.response.statusCode);
      if (error.response.statusCode == 413) {
        return HussainResp.fromError(
          statusCode: error.response.statusCode,
          error: HussainErrResp.fromJson(
              error.response.data is Map<String, dynamic>
                  ? error.response.data
                  : {"message": "Error: Too much data in request"}),
        );
      } else {
        return HussainResp.fromError(
          statusCode: error.response.statusCode,
          error: HussainErrResp.fromJson(
              error.response.data is Map<String, dynamic>
                  ? error.response.data
                  : {"message": "${error.response.statusCode} unknown error"}),
        );
      }
    } else if (error.type == DioErrorType.DEFAULT &&
        error.error is SocketException) {
      return HussainResp.fromError(
        statusCode: 0,
        error: HussainErrResp.fromError(
            "Connection failed, please check your internet connection"),
      );
    } else if (error.type.toString().contains("TIMEOUT")) {
      return HussainResp.fromError(
        statusCode: 0,
        error: HussainErrResp.fromError("Connection Timeout"),
      );
    } else if (error.type == DioErrorType.CANCEL) {
      return HussainResp.fromError(
        statusCode: 0,
        error: HussainErrResp.fromError("Request was canceled"),
      );
    } else {
      return HussainResp.fromError(
        statusCode: 0,
        error: HussainErrResp.fromError(
            "Dio error, TYPE:${error.type} Error:${error.error ?? "error null"}"),
      );
    }
  } else {
    print("unexpected error $error");
    return HussainResp.fromError(
      statusCode: 0,
      error: HussainErrResp.fromError("Unexpected error while making request"),
    );
  }
}

Dio _dio(String token) => Dio(BaseOptions(
      baseUrl: _kioUrl,
      headers: token != null ? {"Authorization": "Bearer $token"} : {},
      responseType: ResponseType.json,
      connectTimeout: 100000,
      receiveTimeout: 100000,
    ));

String prefixBase({@required String onUrl, List<dynamic> param}) {
  if (_kioUrl == null || _kioUrl.isEmpty) {
    throw UnimplementedError(
      "Base url not provided, please call Hussain.initialize(String) before using class",
    );
  }
  final spaces = param.firstWhere((element) => element.toString().contains(" "),
      orElse: () => null);
  if (spaces != null) {
    throw ArgumentError("Spaces not allowed in path parameters");
  }

  String url = "$_kioUrl/$onUrl";
  param.forEach((element) => url = "$url/$element");
  return _removeExtraSlash(url);
}

String _removeExtraSlash(String url) {
  return url.replaceAll(RegExp(r"\/+"), "/").replaceFirst(":/", "://");
}
