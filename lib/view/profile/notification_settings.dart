import 'package:flutter/material.dart';
import 'package:gafamoney/view/activity/activity_tab.dart';
import 'package:gafamoney/view/dashboard/merchant/merchant.dart';
import 'package:gafamoney/view/profile/settings.dart';
import 'package:gafamoney/view/profile/view_qr.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/tabs_gafa_lite.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Notification"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          TabsGafaLite(
            tabs: ["Notification", "Settings"],
            onTabChange: (index, name) {
              setState(() => activeTab = index);
            },
          ),
          Divider(color: Colors.transparent),
          Expanded(child: activeTab == 0 ? Container() : Settings()),
        ]),
      ),
    );
  }
}
