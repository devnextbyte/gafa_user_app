import 'package:flutter/material.dart';
import 'package:gafamoney/utils/gafa_bio.dart';
import 'package:gafamoney/utils/snippets.dart';

class BioButton extends StatelessWidget {
  final void Function(String, String) onPressed;
  final Future<bool> show;

  const BioButton({Key key, @required this.onPressed, @required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: show,
        builder: (context, snap) => snap.hasData
            ? snap.data
                ? TextButton(
                    onPressed: () async {
                      if (await GafaBio.instance.isInitialised()) {
                        onPressed(await GafaBio.instance.getPhone(),
                            await GafaBio.instance.getPin());
                      } else {
                        snack(context,
                            "You need to login with pin once to enable biometric");
                      }
                    },
                    child: Image.asset("assets/images/face_icon.png",
                        height: 20, width: 20),
                  )
                : SizedBox()
            : SizedBox());
  }
}
