import 'package:flutter/material.dart';
import 'package:gafamoney/view/home.dart';
import 'package:gafamoney/view/reusable/password_field.dart';
import 'package:gafamoney/utils/snippets.dart';

class CreatePassword extends StatelessWidget {
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Image.asset("assets/images/create_pass_logo.png",
                width: MediaQuery.of(context).size.width / 2),
            Expanded(child: SizedBox()),
            PasswordField(
              label: "New Password",
              controller: newPassword,
              textInputAction: TextInputAction.next,
            ),
            PasswordField(
              label: "Confirm Password",
              controller: confirmPassword,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Create Password"),
                  onPressed: () {
                    push(context, Home());
                  },
                ),
              ),
            ]),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
