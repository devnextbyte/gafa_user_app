import 'package:flutter/material.dart';
import 'package:gafamoney/model/forget_pass_model.dart';
import 'package:gafamoney/model/signup_model.dart';
import 'package:gafamoney/view/auth/account_info_view.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/auth/new_password_view.dart';

class EnterOtpView extends StatefulWidget {
  final String phoneNumber;
  final ForgetPassReq req;
  final bool forgetPassFlow;
  final bool loading;

  EnterOtpView(
      {Key key,
      @required this.phoneNumber,
      ForgetPassReq request,
      this.loading = false,
      @required this.forgetPassFlow})
      : this.req = request ?? ForgetPassReq(),
        super(key: key);

  @override
  _EnterOtpViewState createState() => _EnterOtpViewState()..loading = loading;
}

class _EnterOtpViewState extends State<EnterOtpView> {
  bool loading = false;

  final otpOne = TextEditingController();
  final otpTwo = TextEditingController();
  final otpThree = TextEditingController();
  final otpFour = TextEditingController();

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("EnterOtpView"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Image.asset("assets/images/forget_logo.png",
                  width: MediaQuery.of(context).size.width / 2),
              Expanded(child: SizedBox()),
              Text(
                "Enter the code that was sent to your number ${widget.phoneNumber}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Expanded(child: SizedBox()),
              getOtpInput(context),
              SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Builder(
                  builder: (context) => loading
                      ? CircularProgressIndicator()
                      : Expanded(
                          child: ElevatedButton(
                            child: Text("Activate Account"),
                            onPressed: () async {
                              if (!key.currentState.validate()) {
                                return;
                              }
                              setState(() {
                                loading = true;
                              });
                              if (widget.forgetPassFlow) {
                                final resp = await widget.req
                                    .requestForgetPassVerify(widget.phoneNumber,
                                        "${otpOne.text}${otpTwo.text}${otpThree.text}${otpFour.text}");

                                if (resp.hasError) {
                                  snack(context, resp.error.errorMessage);
                                } else {
                                  if(resp.response.id.isEmpty){
                                    snack(context, "Phone number is not registered");
                                    setState(() {
                                      loading = false;
                                    });
                                    return;
                                  }
                                  push(
                                      context,
                                      NewPasswordView(
                                        userId: resp.response.id,
                                        token: resp.response.token,
                                      ));
                                }
                              } else {
                                final resp = await requestVerifyOtp.send(
                                  parameters: VerifyOtpParam(
                                    widget.phoneNumber,
                                    "${otpOne.text}${otpTwo.text}${otpThree.text}${otpFour.text}",
                                  ),
                                  token: "dummy",
                                );
                                if (resp.hasError) {
                                  snack(context, resp.error.errorMessage);
                                } else {
                                  push(
                                      context,
                                      AccountInfoView(
                                        token: resp.response.token,
                                        userId: resp.response.id,
                                      ));
                                }
                              }
                              setState(() {
                                loading = false;
                              });
                            },
                          ),
                        ),
                ),
              ]),
              Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  bool anyOtpMiss() =>
      otpOne.text.isEmpty ||
      otpTwo.text.isEmpty ||
      otpThree.text.isEmpty ||
      otpFour.text.isEmpty;

  Widget getOtpInput(BuildContext context) {
    final decoration = InputDecoration(
      errorStyle: TextStyle(height: 0),
      counter: Offstage(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
    return FormField(
      validator: (s) {
        return anyOtpMiss() ? "Enter OTP Please" : null;
      },
      builder: (state) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                child: TextField(
                  key: Key("otpOne"),
                  decoration: decoration,
                  textAlign: TextAlign.center,
                  controller: otpOne,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  onChanged: (t) {
                    if (t.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                child: TextField(
                  decoration: decoration,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  controller: otpTwo,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (t) {
                    if (t.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                child: TextField(
                  decoration: decoration,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: otpThree,
                  textInputAction: TextInputAction.next,
                  onChanged: (t) {
                    if (t.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                child: TextField(
                  decoration: decoration,
                  maxLength: 1,
                  controller: otpFour,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          // Text("Enter OTP Please"),
          state.hasError
              ? Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    state.errorText,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
