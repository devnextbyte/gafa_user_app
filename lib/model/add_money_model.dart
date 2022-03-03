import 'package:flutter/foundation.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/hussain_param.dart';
import 'package:kio/connection/resp/void_resp.dart';
import 'package:kio/external_enum.dart';

Hussain<AddMoneyParam, VoidResp> get requestAddMoney =>
    Hussain<AddMoneyParam, VoidResp>(
      respCreator: (json) => VoidResp.fromJson(json),
      route: "/api/v1/DebitCard/addMoney/",
      type: HussainType.POST,
    );

class AddMoneyParam extends HussainParam {
  final double amount;
  final int cardId;
  final String pin;

  AddMoneyParam({
    @required this.amount,
    @required this.cardId,
    @required this.pin,
  });

  @override
  Map<String, dynamic> toJson() =>
      {"amount": amount, "cardId": cardId, "pin": pin};
}
