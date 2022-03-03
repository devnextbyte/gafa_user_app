import 'package:flutter/cupertino.dart';
import 'package:gafamoney/model/forget_pass_model.dart';

class ForgetPasswordState extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<String> sendRequest(String phoneNumber) async {
    if (phoneNumber == null || phoneNumber.length < 11) {
      return "Invalid phone number";
    }
    loading = true;
    final resp = await ForgetPassReq().requestForgetPass(phoneNumber);
    loading = false;
    return resp.isSuccess ? null : resp.error.errorMessage;
  }
}
