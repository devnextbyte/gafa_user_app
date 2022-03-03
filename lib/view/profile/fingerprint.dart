import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/utils/gafa_bio.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class Fingerprint extends StatefulWidget {
  @override
  _FingerprintState createState() => _FingerprintState();
}

class _FingerprintState extends State<Fingerprint> {
  bool switchPass = false;
  bool switchFingerprint = false;

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  void loadValues() async {
    final sp = await GafaBio.instance.isLoginEnabled();
    final sf = await GafaBio.instance.isTransactionEnabled();
    print("$sp $sf");
    setState(() {
      switchPass = sp ?? false;
      switchFingerprint = sf ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        HeaderBar(title: "Fingerprint", showBackButton: true),
        SizedBox(height: 56),
        getForm(context),
      ]),
    );
  }

  Widget getForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: ListTile.divideTiles(context: context, tiles: [
          ListTile(
            title: Text("Current Password"),
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  "Wallet will use fingerprint saved on the device to log in"),
            ),
            trailing: CupertinoSwitch(
              value: switchPass,
              onChanged: (val) async {
                await GafaBio.instance.setEnableLogin(val);
                loadValues();
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            title: Text("Complete transaction with fingerprint"),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  "Wallet will use fingerprint saved on the device to log in"),
            ),
            trailing: CupertinoSwitch(
              value: switchFingerprint,
              onChanged: (val) async {
                await GafaBio.instance.setEnableTransaction(val);
                loadValues();
              },
            ),
          ),
          SizedBox(),
        ]).toList(),
      ),
    );
  }
}
