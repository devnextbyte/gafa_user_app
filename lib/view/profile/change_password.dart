import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/password_field.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Update Password"),
      body: Column(children: [
        SizedBox(height: 56),
        getForm(context),
      ]),
    );
  }

  Widget getForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          PasswordField(
            controller: pass,
            label: "Current Password",
            validator: mandatoryValidator,
            textInputAction: TextInputAction.next,
          ),
          PasswordField(
            controller: newPass,
            label: "New Password",
            validator: mandatoryValidator,
            textInputAction: TextInputAction.next,
          ),
          PasswordField(
            controller: confirmPass,
            label: "Confirm Password",
            validator: (s) => newPass.text == confirmPass.text
                ? null
                : "Confirm Password does not match",
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 40),
          Builder(
            builder: (context) => loading
                ? Center(child: CircularProgressIndicator())
                : Row(children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              updatePassword(context, pass.text, newPass.text,
                                  confirmPass.text);
                            }
                          },
                          child: Text("Update")),
                    ),
                  ]),
          )
        ]),
      ),
    );
  }

  void updatePassword(BuildContext context, String pass, String newPass,
      String confirmPass) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() => loading = true);
    final resp = await kio.post(
        path: "/api/v1/User/changePassword",
        token: await context.read<AuthState>().token,
        bodyParam: () => {
              "currentPassword": pass,
              "newPassword": newPass,
              "confirmPassword": confirmPass
            });
    setState(() => loading = false);
    if (resp.isSuccess) {
      snack(context, "Password updated successfully", info: true);
    } else {
      snack(context, resp.error.errorMessage);
    }
  }
}
