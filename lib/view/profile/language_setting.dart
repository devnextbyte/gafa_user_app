import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class LanguageSetting extends StatefulWidget {
  @override
  _LanguageSettingState createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  int english = 0;
  int french = 1;
  int groupVal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        HeaderBar(title: "Language", showBackButton: true),
        SizedBox(height: 56),
        getForm(context),
      ]),
    );
  }

  Widget getForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Container(
            color:Theme.of(context).primaryColor.withOpacity(0.1),
            child: RadioListTile(
              value: french,
              groupValue: groupVal,
              onChanged: (v) => setState(() => groupVal = v),
              title: Text("French"),
            ),
          ),
          SizedBox(height:16),
          Container(
            color:Theme.of(context).primaryColor.withOpacity(0.1),
            child: RadioListTile(
              value: english,

              groupValue: groupVal,
              onChanged: (v) => setState(() => groupVal = v),
              title: Text("English"),
            ),
          ),
        ],
      ),
    );
  }
}
