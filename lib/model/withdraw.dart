import 'package:kio/kio.dart';

Hussain<HussainListParam, BankListResp> get requestBankList =>
    Hussain<HussainListParam, BankListResp>(
      respCreator: (json) => BankListResp.fromJson(json),
      // route: "/api/v1/FlutterWave/banks/all",
      route: "/api/v1/bank",
      type: HussainType.GET,
    );

class BankListResp extends HussainOkResp {
  List<BankModel> banks;

  BankListResp.fromJson(json)
      : banks = (json['data'] as List<dynamic>)
            .map((e) => BankModel.fromJson(e))
            .toList(),
        super.fromJson(json);
}

class BankModel extends HussainOkResp {
  String swiftCode;
  String name;
  int id;

  BankModel.fromJson(json)
      : swiftCode = json['swiftCode'],
        name = json['name'],
        id = json['id'],
        super.fromJson(json);
}
