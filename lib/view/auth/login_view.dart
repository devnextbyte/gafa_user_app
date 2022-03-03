import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/gafa_bio.dart';
import 'package:gafamoney/view/auth/signup_view.dart';
import 'package:gafamoney/view/auth/forget_password_view.dart';
import 'package:gafamoney/view/reusable/bio_button.dart';
import 'package:gafamoney/view/reusable/password_field.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';
import 'package:kio/connection/param/hussain_connect_param.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String selectedLanguage = "en";
  final countryCode = TextEditingController();
  final phoneNumberInput = TextEditingController();
  final passwordInput = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("login_screen"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    focusColor: Theme.of(context).primaryColor,
                    key: Key("language_selector"),
                    onChanged: (item) =>
                        setState(() => selectedLanguage = item),
                    value: selectedLanguage,
                    items: ['en', 'fr']
                        .map((e) => DropdownMenuItem(
                              child: Text(e,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox()),
                Image.asset("assets/images/logo.png", key: Key("logo")),
                PhoneField(controller: phoneNumberInput),
                SizedBox(height: 8),
                PasswordField(
                  key: Key("pin"),
                  label: "Pin",
                  controller: passwordInput,
                  textInputAction: TextInputAction.done,
                ),
                Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        push(context, ForgetPasswordView());
                      },
                      child: Text("Forget Password ?"),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    Expanded(child: SizedBox()),
                    Builder(
                      builder: (context) => BioButton(
                          show: GafaBio.instance.isLoginEnabled(),
                          onPressed: (phone, pin) {
                        login(context, phone, pin);
                      }),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Builder(
                    builder: (context) => loading
                        ? CircularProgressIndicator()
                        : Expanded(
                            child: ElevatedButton(
                              child: Text("Login"),
                              onPressed: () async {
                                if (widget.formKey.currentState.validate()) {
                                  login(context, phoneNumberInput.text,
                                      passwordInput.text);
                                }
                              },
                            ),
                          ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New to Gafa?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                    SizedBox(height: 4),
                    FlatButton(
                      onPressed: () {
                        push(context, SignUpView());
                      },
                      child: Text("Create Account"),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    )
                  ],
                ),
                Expanded(flex: 4, child: SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get keyOpen => MediaQuery.of(context).viewInsets.bottom == 0;

  void login(BuildContext context, String phone, String pass) async {
    GafaBio.instance.init(phone, pass);
    setState(() {
      loading = true;
    });
    final resp = await context.read<AuthState>().login(HussainConnectParam(
          userName: phone,
          password: pass,
          role: "Customer",
        ));
    if (resp != null) {
      snack(context, resp);
      setState(() {
        loading = false;
      });
    }
  }
}
