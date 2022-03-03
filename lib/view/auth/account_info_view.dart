import 'package:flutter/material.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/password_field.dart';

class AccountInfoView extends StatefulWidget {
  final String token, userId;

  const AccountInfoView({Key key, @required this.token, @required this.userId})
      : super(key: key);

  @override
  _AccountInfoViewState createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final newPassword = TextEditingController();
  final email = TextEditingController();

  final confirmPassword = TextEditingController();
  bool tnc = false;
  bool loading = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 50,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Image.asset("assets/images/create_acc_logo.png",
                    width: MediaQuery.of(context).size.width / 2),
                Expanded(child: SizedBox()),
                Text(
                  "Please enter your email and password",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                Expanded(child: SizedBox()),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: mandatoryValidator,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                PasswordField(
                  label: "New Pin",
                  controller: newPassword,
                  textInputAction: TextInputAction.next,
                ),
                PasswordField(
                  label: "Confirm Pin",
                  controller: confirmPassword,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 16),
                Row(children: [
                  Checkbox(
                      value: tnc,
                      onChanged: (val) => setState(() => tnc = val)),
                  SizedBox(width: 8),
                  Text("Accept terms and conditions")
                ]),
                SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Builder(
                    builder: (context) => loading
                        ? CircularProgressIndicator()
                        : Expanded(
                            child: ElevatedButton(
                              child: Text("Continue"),
                              onPressed: tnc
                                  ? () async {
                                      if (formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });

                                        final resp =
                                            await requestSetPassword.send(
                                                token: "dummy",
                                                parameters: SetPassParam(
                                                    email.text,
                                                    confirmPassword.text,
                                                    widget.token,
                                                    widget.userId));
                                        if (resp.hasError) {
                                          snack(
                                              context, resp.error.errorMessage);
                                        } else {
                                          popToMain(context);
                                        }

                                        setState(() {
                                          loading = false;
                                        });
                                        // push(context, EnterOtp());
                                      }
                                    }
                                  : null,
                            ),
                          ),
                  ),
                ]),
                Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
