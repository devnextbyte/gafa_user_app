import 'package:flutter/material.dart';
import 'package:gafamoney/view/activity/activity_tab.dart';
import 'package:gafamoney/view/activity/requests_tab.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/tabs_gafa.dart';

class ActivityMain extends StatefulWidget {
  @override
  _ActivityMainState createState() => _ActivityMainState();
}

class _ActivityMainState extends State<ActivityMain> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Activity", showBack: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TabsGafa(
              tabs: ["Request", "Activities"],
              onTabChange: (index, name) {
                setState(() => activeTab = index);
              },
            ),
            Divider(color: Colors.transparent),
            activeTab == 0 ? RequestTab() : ActivityTab(),
          ],
        ),
      ),
    );
  }
}
