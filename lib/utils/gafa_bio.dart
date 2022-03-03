import 'package:kio/kio.dart';
import 'package:local_auth/local_auth.dart';

class GafaBio {
  static final instance = GafaBio();

  final _pinPref = Kamran<String>("GafaBioPin");
  final _phonePref = Kamran<String>("GafaBioPhone");
  final _enableLogin = Kamran<bool>("GafaBioEnableLogin");
  final _enableTransaction = Kamran<bool>("GafaBioEnableTransaction");

  final _localAuth = LocalAuthentication();

  Future<bool> setEnableLogin(bool val) {
    print("sp $val");
    return _enableLogin.save(val);
  }

  Future<bool> setEnableTransaction(bool val) {
    print("sf $val");
    return _enableTransaction.save(val);
  }

  Future<bool> isLoginEnabled() async {
    return ((await _enableLogin.load()) ?? false) &&
        (await _localAuth.canCheckBiometrics);
  }

  Future<bool> isTransactionEnabled() async {
    return ((await _enableTransaction.load()) ?? false) &&
        (await _localAuth.canCheckBiometrics);
  }

  Future<bool> isInitialised() async {
    return (await _pinPref.load()) != null;
  }

  void init(String phone, String pin) {
    _phonePref.save(phone);
    _pinPref.save(pin);
  }

  Future<String> getPhone() async {
    return _phonePref.load();
  }

  Future<String> getPin() async {
    if (await _localAuth.authenticateWithBiometrics(
        localizedReason: "Please authenticate to proceed")) {
      return _pinPref.load();
    } else {
      return null;
    }
  }
}
