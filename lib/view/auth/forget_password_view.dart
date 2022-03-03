import 'package:flutter/material.dart';
import 'package:gafamoney/state/forget_password_state.dart';
import 'package:gafamoney/view/auth/enter_otp.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordState(),
      child: ForgetPasswordViewBody(),
    );
  }
}

class ForgetPasswordViewBody extends StatelessWidget {
  final countryCode = TextEditingController();
  final phoneNumberInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Image.asset("assets/images/forget_logo.png",
                width: MediaQuery.of(context).size.width / 2),
            Expanded(child: SizedBox()),
            Text(
              "We understand you forgot your password 🤗",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Expanded(child: SizedBox()),
            PhoneField(controller: phoneNumberInput),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Builder(
                builder: (context) =>
                    context.watch<ForgetPasswordState>().loading
                        ? CircularProgressIndicator(
                            key: Key("CircularProgressIndicator"))
                        : Expanded(
                            child: ElevatedButton(
                              child: Text("Send OTP"),
                              onPressed: () async {
                                final resp = await context
                                    .read<ForgetPasswordState>()
                                    .sendRequest(phoneNumberInput.text);
                                if (resp != null) {
                                  snack(context, resp);
                                } else {
                                  push(
                                    context,
                                    EnterOtpView(
                                      phoneNumber: phoneNumberInput.text,
                                      forgetPassFlow: true,
                                    ),
                                  );
                                }
                              },
                            ),
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
