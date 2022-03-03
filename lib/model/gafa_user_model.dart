import 'package:kio/connection/resp/hussain_ok_resp.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:kio/kio.dart';

class RecentContactsLine {
  final _requestGetRecentContacts =
      Hussain<HussainListParam, RecentContactsResp>(
    type: HussainType.GET,
    route: "/api/v1/Activity",
    respCreator: (json) => RecentContactsResp.fromJson(json),
  );

  Future<HussainResp<RecentContactsResp>> getRecentContacts(
      String token) async {
    final resp = await _requestGetRecentContacts.send(
      parameters: HussainListParam(),
      token: token,
    );
    return resp;
  }
}

class RecentContactsResp extends HussainOkResp {
  final List<GafaUserModel> users;

  RecentContactsResp.fromJson(json)
      : users = (json['data'] as List<dynamic>)
            .map((e) => GafaUserModel.fromJson(e))
            .toList(),
        super.fromJson(json){
    print(json);
  }
}

class GafaUserModel extends HussainOkResp {
  final String phoneNumber;
  final String name;
  final String userId;
  final String image;

  GafaUserModel.fromJson(json)
      : phoneNumber = json['phoneNumber'],
        name = json['fullName'],
        userId = json['id'],
        image = json['image'],
        super.fromJson(json);
}
