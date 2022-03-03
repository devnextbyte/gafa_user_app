import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/view/activity/activity_main.dart';
import 'package:gafamoney/view/dashboard/dashboard.dart';
import 'package:gafamoney/view/invite.dart';
import 'package:gafamoney/view/more/more_main.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  final screens = [Dashboard(), ActivityMain(), Invite(), MoreMain()];

  static Future<dynamic> backgroundMessageHandler(
    Map<String, dynamic> message,
  ) async {
    return 0;
  }

  @override
  void initState() {
    super.initState();
    final _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? backgroundMessageHandler : null,
    );
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {});
    }
    _firebaseMessaging.getToken().then((token) async {
      print("fcm token $token");
      kio.post(
          path: "/api/v1/User/fcm",
          bodyParam: () => {'fcmId': token},
          token: await context.read<AuthState>().token);
    }).catchError((err) {
      print("fcm token error $err");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        context.read<AuthState>().addNotification();
        print("fcm notification $message");
        showDialogue(message);
        return;
      },
    );
  }

  void showDialogue(message) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: EdgeInsets.only(top: 32.0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      width: 120,
                    ),
                  ],
                ),
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Text(
                    "${message["notification"]["body"]}",
                    style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Icon(Icons.home, color: Colors.white)),
                  )
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/tab_home.png")),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/tab_activity.png")),
              label: 'Activity'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/tab_invite.png")),
              label: 'Invite'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/tab_more.png")),
              label: 'More'),
        ],
      ),
      body: screens.elementAt(index),
    );
  }
}
