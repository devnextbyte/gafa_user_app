import 'package:flutter/material.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class PrintText extends StatelessWidget {
  final String title;

  const PrintText({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title),
      body: Center(
        child: Text("$title text goes here"),
      ),
    );
  }
}
