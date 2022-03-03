import 'package:flutter/foundation.dart';
import 'package:kio/connection/endponts.dart';
import 'package:kio/connection/param/hussain_connect_param.dart';
import 'package:kio/connection/param/hussain_refresh_param.dart';
import 'package:kio/connection/resp/hussain_connect_resp.dart';
import 'package:kio/external_enum.dart';
import 'package:kio/prefrences/kamran_prefs.dart';

abstract class ExternalAuthState extends ChangeNotifier {
  var _statusNotNotAccessDirect = ExternalAuthStatus.INITIALISING;

  ExternalAuthStatus get status {
    return _statusNotNotAccessDirect;
  }

  set _status(ExternalAuthStatus status) {
    _statusNotNotAccessDirect = status;
    print("status changed to ${_statusNotNotAccessDirect.toString()}");
    notifyListeners();
  }

  ExternalAuthState();

  Future<void> refresh() {
    return _refreshToken();
  }

  Future<void> initialise() async {
    // await refresh();
    await _initState();
  }

  Future<String> get token async {
    if (status == ExternalAuthStatus.LOGGED_OUT) {
      throw Exception("Token not supported in logged out state");
    }
    if (await _isTokenExpired) {
      await _refreshToken();
    }
    return kamranPrefs.token.load();
  }

  Future<void> logOut() async {
    await kamranPrefs.token.save(null);
    await kamranPrefs.expiresAtInMillis.save(null);
    await kamranPrefs.refreshToken.save(null);
    _status = ExternalAuthStatus.LOGGED_OUT;
  }

  Future<String> login(HussainConnectParam param) async {
    final resp =
        await hussainEndPoints.connect.send(token: null, parameters: param);
    if (resp.isSuccess) {
      print("logged in");
      await _updateToken(resp.response);
      await kamranPrefs.refreshToken.save(resp.response.refreshToken);
      _status = ExternalAuthStatus.LOGGED_IN;
    } else {
      return resp.error.errorMessage;
    }
    return null;
  }

  Future<void> _initState() async {
    if (await _isDataIncomplete) {
      await logOut();
    } else if ((await token) != null) {
      await refresh();
      _status = ExternalAuthStatus.LOGGED_IN;
    } else {
      await logOut();
    }
  }

  Future<bool> get _isTokenExpired async {
    final expiresAtInMillis = await kamranPrefs.expiresAtInMillis.load();
    final expireAt = DateTime.fromMillisecondsSinceEpoch(expiresAtInMillis);
    return DateTime.now().isAfter(expireAt);
  }

  Future<void> _refreshToken() async {
    final refreshToken = await kamranPrefs.refreshToken.load();
    final connectResp = await hussainEndPoints.refreshToken.send(
        token: null,
        parameters: HussainRefreshParam(refreshToken: refreshToken));
    if (connectResp.isSuccess) {
      await _updateToken(connectResp.response);
    } else {
      logOut();
    }
  }

  Future<void> _updateToken(HussainConnectResp connectResp) async {
    await kamranPrefs.token.save(connectResp.accessToken);
    await kamranPrefs.expiresAtInMillis.save(DateTime.now()
        .add(Duration(seconds: connectResp.exipresIn))
        .millisecondsSinceEpoch);
    await idTokenUpdated(connectResp.idToken);
  }

  Future<void> idTokenUpdated(Map<String, dynamic> idToken);

  Future<bool> get _isDataIncomplete async {
    final expiry = await kamranPrefs.expiresAtInMillis.load();
    final refresh = await kamranPrefs.refreshToken.load();
    final token = await kamranPrefs.token.load();
    return [expiry, refresh, token].any((element) => element == null);
  }
}
