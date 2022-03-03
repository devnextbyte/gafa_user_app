import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("splash_screen"),
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset("assets/images/splash_icon.png"),
        key: Key("logo"),
      ),
    );
  }
}
