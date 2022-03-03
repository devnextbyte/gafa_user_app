import 'package:flutter/cupertino.dart';
import 'package:kio/connection/resp/hussin_resp.dart';

class HussainState extends ChangeNotifier {


  //respCheck will check response for any error and return if error
  String release(HussainHolder holder, {String withError, HussainResp respCheck}) {
    holder._release();
    notifyListeners();
    if (respCheck != null) {
      return respCheck.hasError ? respCheck.error.message : null;
    } else {
      return withError;
    }
  }

  void hold(HussainHolder holder) {
    holder._hold();
    notifyListeners();
  }
}

class HussainHolder {
  bool _holdFlag = false;

  void _hold() {
    _holdFlag = true;
  }

  void _release() {
    _holdFlag = false;
  }

  bool get isHolding => _holdFlag;
}
