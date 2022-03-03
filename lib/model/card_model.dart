import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';
import 'package:kio/kio.dart';

Hussain<HussainListParam, CardResp> get requestCards =>
    Hussain<HussainListParam, CardResp>(
        route: "api/v1/CardHolder",
        type: HussainType.GET,
        respCreator: (json) => CardResp.fromJson(json));

Hussain<AddCardParam, VoidResp> get requestAddCard => Hussain<AddCardParam, VoidResp>(
    route: "api/v1/CardHolder",
    type: HussainType.POST,
    respCreator: (json) => VoidResp.fromJson(json));

class CardResp extends HussainOkResp {
  List<CardModel> data = [];
  int count = 0;

  CardResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CardModel.fromJson(v));
      });
    }
    count = json['count'];
  }
}

class AddCardParam extends HussainParam {
  final String lastDigits;
  final String name;
  final String expiryDate;
  final String token;
  final String zipCode;

  AddCardParam({
    @required this.lastDigits,
    @required this.name,
    @required this.expiryDate,
    @required this.token,
    @required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardType': 1,
      'lastDigits': lastDigits,
      'name': name,
      'expiryDate': expiryDate,
      'token': token,
      'email':"dummy_email@gmail.com"
    };
  }
}


class CardModel {
  int id;
  String customer;
  String name;
  int cardType;
  String createdDate;
  String expiryDate;
  String lastDigits;

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    name = json['name'];
    cardType = json['cardType'];
    createdDate = json['createdDate'];
    expiryDate = json['expiryDate'];
    lastDigits = json['lastDigits'];
  }
}
