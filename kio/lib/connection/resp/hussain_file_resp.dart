import 'package:kio/connection/resp/hussain_ok_resp.dart';

class HussainFileResponse extends HussainOkResp {
  final dynamic fileBytes;
  // File _file;
  // final String _fileName;

  // Future<File> get file async {
  //   if (_file == null) {
  //     final tempDir = await getExternalCacheDirectories();
  //     String fullPath = tempDir[0].path + "/$_fileName";
  //     _file = await File(fullPath).writeAsBytes(_fileBytes);
  //   }
  //   return _file;
  // }

  HussainFileResponse.fromJson(json)
      :fileBytes = json,
        super.fromJson(json);
}
