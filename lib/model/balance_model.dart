import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/void_param.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';
import 'package:kio/external_enum.dart';

Hussain<VoidParam, BalanceResp> get requestBalance =>
    Hussain<VoidParam, BalanceResp>(
      type: HussainType.GET,
      route: "/api/v1/User/balance/",
      respCreator: (json) => BalanceResp.fromJson(json),
    );

class BalanceResp extends HussainOkResp {
  final double balance;

  BalanceResp.fromJson(json)
      : balance = json['data'] + 0.0,
        super.fromJson(json);
}
