import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/hussain_connect_param.dart';

void main() {
  Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");

  test("Login test", () async {
    final authState = AuthState();
    final resp = await authState.login(HussainConnectParam(
        userName: "+221123456786", password: "1234", role: "Customer"));

    expect(resp, null);
  });
}
