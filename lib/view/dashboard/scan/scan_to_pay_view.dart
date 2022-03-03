import 'package:flutter/material.dart';
import 'package:gafamoney/view/dashboard/scan/scan_code_tab.dart';
import 'package:gafamoney/view/profile/view_qr.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/tabs_gafa_lite.dart';

class ScanToPayView extends StatefulWidget {
  @override
  _ScanToPayViewState createState() => _ScanToPayViewState();
}

class _ScanToPayViewState extends State<ScanToPayView> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Scan QR Code"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          TabsGafaLite(
            tabs: ["Scan Code", "Gafa Me"],
            onTabChange: (index, name) {
              setState(() => activeTab = index);
            },
          ),
          Divider(color: Colors.transparent),
          Expanded(child: activeTab == 0 ? ScanCodeTab() : ViewQr()),
        ]),
      ),
    );
  }

  void scanQr() async {
    // String scanResult = await QRCodeReader().setTorchEnabled(true).scan();
    // if (scanResult != null && scanResult.isNotEmpty) {
    //   if (scanResult.startsWith("gafaPhone")) {
    //     final phoneNumber = scanResult.replaceFirst("gafaPhone", "");
    //     push(
    //         context,
    //         EnterAmount(
    //           heading: "Send Money",
    //           sending: true,
    //           title: phoneNumber,
    //           subTitle: "",
    //           icon: Icon(FontAwesomeIcons.user,
    //               color: Theme.of(context).primaryColor),
    //           onAmountEntered: (amount) =>
    //               amountEntered(context, phoneNumber, amount),
    //         ));
    //   } else {
    //     snack(context, "Invalid qrcode");
    //   }
    // }
  }

}
