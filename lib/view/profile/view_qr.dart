import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

import 'package:share/share.dart';

class ViewQr extends StatelessWidget {
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 10),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10),
          RepaintBoundary(
            key: key,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      context.read<AuthState>().fullName,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 16),
                    QrImage(
                        data:
                            "gafaPhone${context.watch<AuthState>().phoneNumber}"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () => _capturePng(context),
                      child: Text("Share to pay"))),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _capturePng(BuildContext context) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // print(pngBytes);
    final file = await writeToFile(byteData);
    Share.shareFiles([file.path],
        text:
            "Scan this to pay ${context.read<AuthState>().fullName} using Gafa app");
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final filePath = tempPath + '/file_01.png';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    return file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
