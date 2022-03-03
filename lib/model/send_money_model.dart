import 'package:flutter/cupertino.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/param/hussain_param.dart';
import 'package:kio/kio.dart';

Hussain<SendMoneyParam, VoidResp> get requestSendMoney =>
    Hussain<SendMoneyParam, VoidResp>(
        type: HussainType.POST,
        route: "/api/v1/Payment/sendMoney",
        respCreator: (json) => VoidResp.fromJson(json));

Hussain<WithdrawParam, VoidResp> get requestWithdraw =>
    Hussain<WithdrawParam, VoidResp>(
        type: HussainType.POST,
        route: "/api/v1/FlutterWave/withdraw",
        respCreator: (json) => VoidResp.fromJson(json));

Hussain<CreditBankParam, VoidResp> get requestAddByBank =>
    Hussain<CreditBankParam, VoidResp>(
        type: HussainType.POST,
        route: "/api/v1/DebitCard/addMoneyByBank",
        respCreator: (json) => VoidResp.fromJson(json));

class WithdrawParam extends HussainParam {
  final int branchId;

  final String pin;
  final String bankCode;
  final String accountNumber;
  final double amount;
  final String name;

  WithdrawParam({
    @required this.branchId,
    @required this.pin,
    @required this.bankCode,
    @required this.accountNumber,
    @required this.amount,
    @required this.name,
  });

  @override
  Map<String, dynamic> toJson() => {
        "branchId": branchId,
        "pin": pin,
        "bankCode": bankCode,
        "accountNumber": accountNumber,
        "amount": amount,
        "name": name
      };
}

class CreditBankParam extends HussainParam {
  final String pin;
  final int bankId;
  final String accountNo;
  final double amount;
  final String accountName;

  CreditBankParam({
    @required this.pin,
    @required this.bankId,
    @required this.accountNo,
    @required this.amount,
    @required this.accountName,
  });

  @override
  Map<String, dynamic> toJson() => {
        "pin": pin,
        "bankId": bankId,
        "accountNo": accountNo,
        "amount": amount,
        "accountName": accountName
      };
}

class SendMoneyParam extends HussainParam {
  final String pin;
  final String phoneNumber;
  final double amount;

  SendMoneyParam({
    @required this.pin,
    @required this.phoneNumber,
    @required this.amount,
  });

  @override
  Map<String, dynamic> toJson() =>
      {"phoneNumber": phoneNumber, "amount": amount, "pin": pin};
}
