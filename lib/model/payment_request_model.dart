import 'package:intl/intl.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';

// public enum RequestStatus {
//    None = 0,
//    Accepted = 1,
//    Rejected = 2,
//    Cancelled = 3
// }

class PaymentRequestResp extends HussainOkResp {
  List<PaymentRequestItemModel> data;
  int count;

  PaymentRequestResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new PaymentRequestItemModel.fromJson(v));
      });
    }
    count = json['count'];
  }
}

class PaymentRequestItemModel extends HussainOkResp {
  String sender;
  String receiver;
  int requestId;
  final String createdDate;
  double amount;
  int status;
  bool isSender;

  String get formatedDateTime =>
      DateFormat.jm().format(DateTime.parse(createdDate).toLocal()) +
      " " +
      DateFormat.yMd().format(DateTime.parse(createdDate).toLocal());

  PaymentRequestItemModel.fromJson(Map<String, dynamic> json)
      : createdDate = json['createdDate'],
        super.fromJson(json) {
    sender = json['sender'];
    receiver = json['receiver'];
    requestId = json['requestId'];
    amount = json['amount'].toDouble();
    status = json['status'];
    isSender = json['isSender'];
  }
}
