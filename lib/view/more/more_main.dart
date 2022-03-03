import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/more/print_text.dart';

class MoreMain extends StatelessWidget {
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
              title: Text("About Gafa"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(context, PrintText(title: "About Gafa")),
            ),
            ListTile(
              title: Text("Terms and Conditions"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () =>
                  push(context, PrintText(title: "Terms & Conditions")),
            ),
            ListTile(
              title: Text("Privacy Policy"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => push(context, PrintText(title: "Privacy Policy")),
            ),
            SizedBox(),
          ],
        ).toList(),
      ),
    );
  }

  Widget getHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height / 6,
      padding: EdgeInsets.fromLTRB(24, 54, 24, 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text("More",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
      ),
    );
  }
}
