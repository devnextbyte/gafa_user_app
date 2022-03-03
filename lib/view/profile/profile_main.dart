import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/profile/edit_profile.dart';
import 'package:gafamoney/view/profile/language_setting.dart';
import 'package:gafamoney/view/profile/login_security.dart';
import 'package:gafamoney/view/profile/notification_settings.dart';
import 'package:gafamoney/view/profile/settings.dart';
import 'package:gafamoney/view/profile/view_qr.dart';
import 'package:kio/connection/hussain.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          getHeader(context),
          getOptions(context),
        ],
      ),
    );
  }

  Widget getOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(context, EditProfile()),
            ),
            ListTile(
              title: Text("Login & Security"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(context, LoginAndSecurity()),
            ),
            ListTile(
              title: Row(
                children: [
                  Text("Notification and settings"),
                  SizedBox(width: 16),
                  context.watch<AuthState>().notifications == 0
                      ? SizedBox()
                      : Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                                child: Text(
                                    "${context.watch<AuthState>().notifications}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(color: Colors.white))),
                          )),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                context.read<AuthState>().clearNotifications();
                return push(context, NotificationSettings());
              },
            ),
            ListTile(
              title: Text("Language"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(context, LanguageSetting()),
            ),
            ListTile(
              title: Text("Logout"),
              // trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () async {
                showDialogue(context);
              },
            ),
            SizedBox(),
          ],
        ).toList(),
      ),
    );
  }

  void showDialogue(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: EdgeInsets.only(top: 32.0),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logout.png',
                      fit: BoxFit.contain,
                      width: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Are you sure you want to Log out ?",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Gafa requires your password to confirm each transaction so you don't need to log out",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                pop(context);
                              },
                              elevation: 0,
                              child: Text("Cancel"),
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              textColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () async {
                                await context.read<AuthState>().logOut();
                                pop(context);
                                pop(context);
                              },
                              elevation: 0,
                              child: Text("Log out"),
                              color: Colors.grey.shade100,
                              textColor: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
    });
  }

  Widget getHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height / 4,
      padding: EdgeInsets.fromLTRB(24, 54, 24, 24),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                Hussain.prefixBase(onUrl: context.watch<AuthState>().image),
                width: 64,
                fit: BoxFit.fill,
                height: 64,
                errorBuilder: (a, b, c) => Icon(Icons.error_outline,
                    color: Theme.of(context).errorColor),
              ),
            ),
            SizedBox(width: 16),
            Text(
              "${context.watch<AuthState>().fullName.replaceAll(" ", "\n")}",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
            Expanded(child: SizedBox()),
            RaisedButton.icon(
              onPressed: () {
                push(context, ViewQr());
              },
              label: Text("My QrCode"),
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              icon: Icon(FontAwesomeIcons.qrcode, size: 16),
            )
          ],
        ),
      ),
    );
  }
}
