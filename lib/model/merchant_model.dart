import 'package:kio/connection/resp/hussain_ok_resp.dart';

class MerchantModel extends HussainOkResp {
  final String fullName;
  final String phoneNumber;
  final String image;
  final String id;
  final String tillNumber;
  final int shopId;

  MerchantModel.fromJson(json)
      : fullName = json['data']['fullName'],
        phoneNumber = json['data']['phoneNumber'],
        image = json['data']['image'],
        id =  json['data']['id'],
        tillNumber = json['data']['tillNumber'],
        shopId = json['data']['shopId'],
        super.fromJson(json);
}
