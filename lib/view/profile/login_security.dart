import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/profile/change_password.dart';
import 'package:gafamoney/view/profile/fingerprint.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class LoginAndSecurity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        HeaderBar(title: "Login & Security", showBackButton: true),
        SizedBox(height: 54),
        getOptions(context)
      ]),
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
              title: Text("Password"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(
                context,
                ChangePassword(),
              ), // push(context, EditProfile()),
            ),
            ListTile(
              title: Text("Fingerprint"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(
                context,
                Fingerprint(),
              ),
            ),
            SizedBox(),
          ],
        ).toList(),
      ),
    );
  }
}
