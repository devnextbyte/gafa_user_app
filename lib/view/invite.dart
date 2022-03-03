import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Invite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getHeader(context),
            getShareCode(context),
          ],
        ),
      ),
    );
  }

  Widget getShareCode(BuildContext context) {
    return Column(
      children: [
        Text(
          "Let your friends and family know how much time and money they can save on their transaction with GAFA",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: getCode(context)),
            SizedBox(width: 8),
            FlatButton(
              padding: EdgeInsets.fromLTRB(36, 18, 36, 18),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                Share.share(
                  'Yo! Check out this sick app. I deal my money n\' stuff with it. You should too. Sign up with my referral code \"${context.read<AuthState>().referral}\" to get a sweet bonus!',
                );
              },
              child: Text("Share"),
            )
          ],
        ),
      ],
    );
  }

  Widget getCode(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Expanded(child: Text(context.watch<AuthState>().referral)),
          Builder(
            builder: (context) => FlatButton(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                FlutterClipboard.copy(context.read<AuthState>().referral).then(
                  (value) => snack(
                      context, "Your referral code is copied to clipboard",
                      info: true),
                );
              },
              child: Text("Copy"),
            ),
          )
        ],
      ),
    );
  }

  Widget getHeader(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        children: [
          Image.asset("assets/images/invite.png"),
          SizedBox(height: 16),
          Text(
            "Invite friends and Earn",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
