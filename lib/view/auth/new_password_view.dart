import 'package:flutter/material.dart';
import 'package:gafamoney/model/forget_pass_model.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/password_field.dart';

class NewPasswordView extends StatefulWidget {
  final bool loading;
  final ForgetPassReq line;
  final String token;
  final String userId;

  NewPasswordView({
    Key key,
    this.loading = false,
    ForgetPassReq line,
    @required this.token,
    @required this.userId,
  })  : this.line = line ?? ForgetPassReq(),
        super(key: key);

  @override
  _NewPasswordViewState createState() =>
      _NewPasswordViewState()..loading = this.loading;
}

class _NewPasswordViewState extends State<NewPasswordView> {
  bool loading;
  final newPin = TextEditingController();

  final confirmPin = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Image.asset("assets/images/create_pass_logo.png",
                width: MediaQuery.of(context).size.width / 2),
            Expanded(child: SizedBox()),
            PasswordField(controller: newPin, label: "New Pin"),
            PasswordField(
              controller: confirmPin,
              label: "Confirm Pin",
              validator: (s) => s == newPin.text
                  ? null
                  : "Confirm pin does not match with new pin",
            ),
            SizedBox(height: 8),
            Builder(
              builder: (context) => loading
                  ? CircularProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                final resp = await widget.line.requestNewPass(
                                    widget.token,
                                    widget.userId,
                                    confirmPin.text);
                                setState(() {
                                  loading = false;
                                });
                                if (resp.hasError) {
                                  snack(context, resp.error.errorMessage);
                                } else {
                                  popToMain(context);
                                }
                              }
                            },
                            child: Text("Change Password"),
                          ),
                        ),
                      ],
                    ),
            ),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    ));
  }
}
