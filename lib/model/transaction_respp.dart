import 'package:kio/connection/resp/hussain_ok_resp.dart';

class TransactionResponse extends HussainOkResp {
  List<TransactionData> data;
  int count;

  TransactionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      data = [];
      if (json['data'] is List) {
        json['data'].forEach((v) {
          data.add(new TransactionData.fromJson(v));
        });
      } else {
        data.add(new TransactionData.fromJson(json['data']));
      }
    }
  }
}

class TransactionData extends HussainOkResp {
  String _transactionId;
  String loadType;
  String fromName;
  String toName;
  String message;
  double amount;
  double tax;
  double fee;
  double net;
  String date;
  String image;
  bool pending;

  // String get formatDate => "${DateFormat.yMd().format(DateTime.parse(date).toLocal())}\n${DateFormat.Hm().format(DateTime.parse(date).toLocal())}";

  String get transactionId => _transactionId == null || _transactionId.isEmpty
      ? ""
      : _transactionId.split("-")[_transactionId.split("-").length - 1];

  TransactionData.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    print(json);
    _transactionId = json['transactionId'];
    loadType = json['loadType'] != null ? "${json['loadType']}" : null;
    fromName = json['from'];
    toName = json['to'];
    message = json['message'];
    amount = json['amount']?.toDouble() ?? null;
    tax = json['tax']?.toDouble() ?? null;
    net = json['net']?.toDouble() ?? null;
    fee = json['fee']?.toDouble() ?? null;
    date = json['date'];
    pending = json['isPending'];
    image = json['image'];
  }
}
