import 'package:flutter/material.dart';
import 'package:gafamoney/model/customer_model.dart';
import 'package:gafamoney/model/send_money_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';
import 'package:gafamoney/view/reusable/recent_contacts_view.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:kio/kio.dart';
import 'package:provider/provider.dart';

class UserSendOrRequest extends StatefulWidget {
  final String title;
  final bool forRequest;

  const UserSendOrRequest.forSend({@required this.title}) : forRequest = false;

  const UserSendOrRequest.forRequest({@required this.title})
      : forRequest = true;

  @override
  _UserSendOrRequestState createState() => _UserSendOrRequestState();
}

class _UserSendOrRequestState extends State<UserSendOrRequest> {
  final phoneNumber = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: PhoneField(controller: phoneNumber)),
                      Image.asset("assets/images/my_contacts.png", width: 32),
                    ],
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Frequent Contact",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(height: 16),
                  Builder(
                    builder: (builder) => RecentContactsView(
                      phoneSelected: (phoneNumber) =>
                          phoneEntered(context, phoneNumber),
                    ),
                  ),
                  SizedBox(height: 32),
                  Builder(
                    builder: (context) => loading
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      phoneEntered(context, phoneNumber.text);
                                    }
                                  },
                                  child: Text("Continue"),
                                ),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void phoneEntered(BuildContext context, String phoneNumber) async {
    setState(() => loading = true);
    final resp = await kio.get<CustomerModel>(
        path: "/api/v1/Customer/phone",
        respGen: (json) => CustomerModel.fromJson(json),
        token: await context.read<AuthState>().token,
        bodyParam: () => {"PhoneNumber": phoneNumber});
    setState(() => loading = false);

    if (widget.forRequest) {
      if (resp.statusCode != 200) {
        snack(context,
            "No user found with this phone number, use the invite tab to invite then on gafapay");
        return;
      }
      push(
          context,
          EnterAmount(
            heading: "Request Money",
            sending: false,
            title: resp.response.name,
            subTitle: phoneNumber,
            icon: Image.network(Hussain.prefixBase(onUrl: resp.response.image)),
            onAmountEntered: (amount) =>
                sendRequestAction(context, phoneNumber, amount),
          ));
    } else {
      if (resp.statusCode != 200) {
        snack(context,
            "No user found with this phone number, Invite them or send money using cash pickup option");
        return;
      }
      push(
          context,
          EnterAmount(
            heading: "Send Money",
            sending: true,
            title: resp.response.name,
            subTitle: phoneNumber,
            icon: Image.network(Hussain.prefixBase(onUrl: resp.response.image)),
            onAmountEntered: (amount) =>
                sendMoneyAmountEntered(context, phoneNumber, amount),
          ));
    }
  }

  Future<String> sendMoneyAmountEntered(
    BuildContext context,
    String phoneNumber,
    double amount,
  ) async {
    push(
        context,
        TransactionReceipt(
            heading: "Send Money",
            from: "Gafa Account",
            to: phoneNumber,
            amount: amount,
            onPinEntered: (pin) =>
                sendMoneyAction(context, phoneNumber, amount, pin)));
    return null;
  }

  Future<String> sendMoneyAction(
    BuildContext context,
    String phoneNumber,
    double amount,
    String pin,
  ) async {
    final resp = await requestSendMoney.send(
        token: await context.read<AuthState>().token,
        parameters: SendMoneyParam(
          amount: amount,
          phoneNumber: phoneNumber,
          pin: pin,
        ));
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message: "You sent ${amount.toStringAsFixed(2)} to $phoneNumber",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }

  Future<String> sendRequestAction(
      BuildContext context, String phoneNumber, double amount) async {
    final resp = await kio.post(
        path: "/api/v1/Request",
        token: await context.read<AuthState>().token,
        bodyParam: () => {
              "phoneNumber": phoneNumber,
              "amount": amount,
              // "pin": "1111",
            });
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message: "Wait till $phoneNumber accepts your payment request",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }
}
