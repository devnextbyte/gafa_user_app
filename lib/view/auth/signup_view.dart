import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/auth/enter_otp.dart';
import 'package:gafamoney/view/reusable/date_field.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final phoneController = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final referralCode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dateOfBirth = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/logo.png",
                        key: Key("logo"),
                        height: MediaQuery.of(context).size.width / 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          PhoneField(controller: phoneController),
                          TextFormField(
                              controller: firstName,
                              decoration:
                                  InputDecoration(labelText: "First Name"),
                              validator: mandatoryValidator),
                          TextFormField(
                              controller: lastName,
                              decoration:
                                  InputDecoration(labelText: "Last Name"),
                              validator: mandatoryValidator),
                          DateInputFormField(
                            controller: dateOfBirth,
                            isRequired: true,
                            label: "Date of birth",
                          ),
                          TextFormField(
                              controller: referralCode,
                              decoration: InputDecoration(
                                  labelText: "Referral Code (Optional)")),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Builder(
                                builder: (context) => loading
                                    ? CircularProgressIndicator()
                                    : Expanded(
                                        child: ElevatedButton(
                                          child: Text("Sign Up"),
                                          onPressed: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              final resp =
                                                  await requestSignUp.send(
                                                parameters: SignUpParam(
                                                    phoneController.text,
                                                    "${firstName.text} ${lastName.text}",
                                                    referralCode.text,dateOfBirth.text),
                                                token: "dummy",
                                              );
                                              setState(() {
                                                loading = false;
                                              });
                                              if (resp.hasError) {
                                                snack(context,
                                                    resp.error.message);
                                              } else {
                                                push(
                                                    context,
                                                    EnterOtpView(
                                                      phoneNumber:
                                                          phoneController.text,
                                                      forgetPassFlow: false,
                                                    ));
                                              }
                                            }
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
