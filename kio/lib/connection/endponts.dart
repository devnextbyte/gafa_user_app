import 'package:kio/connection/param/hussain_connect_param.dart';
import 'package:kio/connection/param/hussain_refresh_param.dart';
import 'package:kio/connection/resp/hussain_connect_resp.dart';
import 'package:kio/external_enum.dart';

import 'hussain.dart';

HussainEndPoints get hussainEndPoints{
  if(HussainEndPoints._hussainEndPoints == null){
    HussainEndPoints._hussainEndPoints = HussainEndPoints();
  }
  return HussainEndPoints._hussainEndPoints;
}
class HussainEndPoints {
  static var _hussainEndPoints = HussainEndPoints();
  final Hussain<HussainRefreshParam, HussainConnectResp> refreshToken = Hussain<HussainRefreshParam, HussainConnectResp>(
      route: "/connect/token",
      type: HussainType.POST,
      respCreator: (json) => HussainConnectResp.fromJson(json));


  final Hussain<HussainConnectParam, HussainConnectResp> connect = Hussain<HussainConnectParam, HussainConnectResp>(
      route: "/connect/token",
      type: HussainType.POST,
      respCreator: (json) => HussainConnectResp.fromJson(json));
}
