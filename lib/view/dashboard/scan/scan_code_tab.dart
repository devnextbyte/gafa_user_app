import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/model/send_money_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanCodeTab extends StatefulWidget {
  @override
  _ScanCodeTabState createState() => _ScanCodeTabState();
}

class _ScanCodeTabState extends State<ScanCodeTab> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset("assets/images/flash.png", width: 56),
            onTap: () {
              controller.toggleFlash();
            },
          ),
          SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final scanResult = scanData.code;
      if (scanResult != null && scanResult.isNotEmpty) {
        if (scanResult.startsWith("gafaPhone")) {
          final phoneNumber = scanResult.replaceFirst("gafaPhone", "");
          push(
              context,
              EnterAmount(
                heading: "Send Money",
                sending: true,
                title: phoneNumber,
                subTitle: "",
                icon: Icon(FontAwesomeIcons.user,
                    color: Theme.of(context).primaryColor),
                onAmountEntered: (amount) =>
                    amountEntered(context, phoneNumber, amount),
              ));
        } else {
          snack(context, "Invalid qrcode");
        }
      }
    });
  }

  Future<String> amountEntered(
    BuildContext context,
    String phoneNumber,
    double amount,
  ) async {
    push(
        context,
        TransactionReceipt(
            heading: "Send Money",
            from: "Gafa Account",
            to: phoneNumber,
            amount: amount,
            onPinEntered: (pin) =>
                sendMoney(context, phoneNumber, amount, pin)));
    return null;
  }

  Future<String> sendMoney(
    BuildContext context,
    String phoneNumber,
    double amount,
    String pin,
  ) async {
    final resp = await requestSendMoney.send(
        token: await context.read<AuthState>().token,
        parameters: SendMoneyParam(
          amount: amount,
          phoneNumber: phoneNumber,
          pin: pin,
        ));
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message: "You sent ${amount.toStringAsFixed(2)} to $phoneNumber",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
