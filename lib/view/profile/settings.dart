import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool switchPass = false;
  bool switchFingerprint = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      getForm(context),
    ]);
  }

  Widget getForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text("Push Notification"),
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Get push notification for your transaction "),
              ),
              trailing: CupertinoSwitch(
                value: switchFingerprint,
                onChanged: (val) => setState(() => switchFingerprint = val),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              title: Text("Email Notifications"),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child:
                    Text("Receive email notification form your transaction "),
              ),
              trailing: CupertinoSwitch(
                value: switchPass,
                onChanged: (val) => setState(() => switchPass = val),
              ),
            ),
            SizedBox(),
          ],
        ).toList(),
      ),
    );
  }
}
