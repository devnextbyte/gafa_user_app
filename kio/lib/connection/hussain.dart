import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_param.dart';
import 'package:kio/connection/resp/hussain_err_resp.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';
import '../external_enum.dart';
import 'resp/hussin_resp.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class Hussain<P extends HussainParam, R extends HussainOkResp> {
  static String _baseUrl = "https://api.gafapay.nextbytesolutions.com/";

  static void initialize({String baseUrl}) {
    _baseUrl = baseUrl;
  }

  static String prefixBase({@required String onUrl}) {
    if (_baseUrl == null || _baseUrl.isEmpty) {
      throw UnimplementedError(
        "Base url not provided, please call Hussain.initialize(String) before using class",
      );
    }
    return _removeExtraSlash("$_baseUrl/$onUrl");
  }

  static String _removeExtraSlash(String url) {
    return url.replaceAll(RegExp(r"\/+"), "/").replaceFirst(":/", "://");
  }

  final String _url;
  final HussainType _type;
  final R Function(dynamic) _respCreator;

  Hussain copyWith({String route, HussainType type}) => Hussain<P, R>(
      route: route == null ? _url : prefixBase(onUrl: route),
      type: type ?? _type,
      respCreator: _respCreator);

  Hussain({
    @required HussainType type,
    @required String route,
    @required R Function(dynamic) respCreator,
  })  : this._url = prefixBase(onUrl: route),
        _type = type,
        _respCreator = respCreator;

  Future<HussainResp<R>> send({
    String token,
    Future<String> futureToken,
    @required P parameters,
  }) async {
    if (token == null && futureToken != null) {
      token = await futureToken;
    }
    // token = token??"dummy";

    Response<dynamic> dioResponse;
    R hussinResponse;
    String requestUrl = getUrlWithPathVar(parameters);
    print("Calling $requestUrl with $_type");
    print("with param ${parameters.toJson()}");

    try {
      switch (_type) {
        case HussainType.GET:
          dioResponse = await _dio(token).get(requestUrl,
              queryParameters: parameters.toJson(), options: _options(token));
          break;
        case HussainType.POST:
          dioResponse = await _dio(token).post(requestUrl,
              data: parameters.toJson(), options: _options(token));
          break;
        case HussainType.PUT:
          dioResponse = await _dio(token).put(requestUrl,
              data: parameters.toJson(), options: _options(token));
          break;
        case HussainType.DELETE:
          dioResponse = await _dio(token).delete(requestUrl,
              queryParameters: parameters.toJson(), options: _options(token));
          break;
        case HussainType.BYTE:
          dioResponse = await _dio(token).get(requestUrl,
              queryParameters: parameters.toJson(),
              options: _options(token, bytes: true));
          break;
      }
    } catch (error) {
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
              error: HussainErrResp.fromJson(error.response.data
                      is Map<String, dynamic>
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
          HussainResp.fromError(
            statusCode: 0,
            error: HussainErrResp.fromError(
                "Dio error, TYPE:${error.type} Error:${error.error ?? "error null"}"),
          );
        }
      } else {
        return HussainResp.fromError(
          statusCode: 0,
          error:
              HussainErrResp.fromError("Unexpected error while making request"),
        );
      }
    }
    // print(dioResponse.data);
    try {
      hussinResponse = _respCreator(dioResponse.data);
    } catch (error) {
      print("parse response error: $error");
      return HussainResp.fromError(
        statusCode: dioResponse.statusCode,
        error: HussainErrResp.fromError("Failed to parse response"),
      );
    }
    print("request success");
    return HussainResp.fromSuccess(
        statusCode: dioResponse.statusCode, response: hussinResponse);
  }

  String getUrlWithPathVar(P parameters) {
    String pathVarUrl = _url;
    if (parameters.pathParam() != null) {
      parameters
          .pathParam()
          .forEach((element) => pathVarUrl = "$pathVarUrl/$element");
    }
    return _removeExtraSlash(pathVarUrl);
  }

  Dio _dio(String token) => Dio(BaseOptions(
        baseUrl: _baseUrl,
        headers: {"Authorization": "Bearer $token"},
        responseType: ResponseType.json,
        connectTimeout: 100000,
        receiveTimeout: 100000,
      ));

  Options _options(String token, {bytes = false}) => Options(
        responseType: bytes ? ResponseType.bytes : ResponseType.json,
        contentType: ContentType.parse(token != null && token.isNotEmpty
                ? "application/json"
                : "application/x-www-form-urlencoded")
            .toString(),
      );
}
