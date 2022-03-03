import 'package:kio/connection/resp/hussain_ok_resp.dart';

class CustomerModel extends HussainOkResp {
  final String name;
  final String phone;
  final String image;

  CustomerModel.fromJson(json)
      : name = json['data']['name'],
        phone = json['data']['phone'],
        image = json['data']['image'],
        super.fromJson(json);
}
