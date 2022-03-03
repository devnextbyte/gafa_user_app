import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:kio/kio.dart';

class CompanyListLine {
  Hussain<HussainListParam, CompanyListResp> get _reqComp =>
      Hussain<HussainListParam, CompanyListResp>(
        respCreator: (json) => CompanyListResp.fromJson(json),
        route: "/api/v1/Company",
        type: HussainType.GET,
      );

  Hussain<PayBillParam, VoidResp> get requestPayBill =>
      Hussain<PayBillParam, VoidResp>(
        type: HussainType.POST,
        route: "/api/v1/Bill",
        respCreator: (json) => VoidResp.fromJson(json),
      );

  Future<HussainResp<CompanyListResp>> getCompaniesList(String token) {
    return _reqComp.send(parameters: HussainListParam(), token: token);
  }
}

class PayBillParam extends HussainParam {
  final String billNo;
  final int companyId;
  final String referenceNo;
  final double amount;
  final String pin;

  PayBillParam({
    @required this.billNo,
    @required this.companyId,
    @required this.referenceNo,
    @required this.amount,
    @required this.pin,
  });

  @override
  Map<String, dynamic> toJson() => {
        "billNo": billNo,
        "companyId": companyId,
        "referenceNo": referenceNo,
        "pin": pin,
        "amount": amount
      };
}

class CompanyListResp extends HussainOkResp {
  List<CompanyModel> _companies;

  CompanyListResp.fromJson(json)
      : _companies = (json['data'] as List<dynamic>)
            .map((e) => CompanyModel.fromJson(e))
            .toList(),
        super.fromJson(json);

  List<CompanyModel> getBillPaymentCompanies() =>
      _companies.where((element) => element.type == 1).toList();

  List<CompanyModel> getAirtimeTopUpCompanies() =>
      _companies.where((element) => element.type == 2).toList();
}

class CompanyModel {
  final String name;
  final int companyId;
  final String imageUrl;
  final int type;

  CompanyModel({this.name, this.companyId, this.imageUrl, this.type});

  CompanyModel.fromJson(json)
      : name = json['name'],
        companyId = json['companyId'],
        imageUrl = json['imageUrl'],
        type = json['type'];
}
