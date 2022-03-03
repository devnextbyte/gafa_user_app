import 'package:kio/connection/resp/hussain_err_resp.dart';
import 'package:kio/connection/resp/hussain_ok_resp.dart';
import 'package:kio/connection/resp/hussin_resp.dart';

dynamic get emptyList => {"data": []};

HussainResp<T> getServerErrResp<T extends HussainOkResp>() =>
    HussainResp<T>.fromError(
        statusCode: 400,
        error: HussainErrResp.fromJson({
          "message": "Error from server",
        }));
