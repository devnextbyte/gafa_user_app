import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:gafamoney/view/reusable/phone_input.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:kio/connection/resp/void_resp.dart';
import 'package:provider/provider.dart';

class SendCashPickup extends StatefulWidget {
  @override
  _SendCashPickupState createState() => _SendCashPickupState();
}

class _SendCashPickupState extends State<SendCashPickup> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNum = TextEditingController();
  final address = TextEditingController();
  final nic = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar("Cash Pickup"),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: mandatoryValidator,
                    decoration: InputDecoration(labelText: "First Name"),
                    controller: firstName),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: mandatoryValidator,
                    decoration: InputDecoration(labelText: "Last Name"),
                    controller: lastName),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: PhoneField(controller: phoneNum)),
                  Image.asset("assets/images/my_contacts.png", width: 32),
                ]),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: mandatoryValidator,
                    decoration: InputDecoration(labelText: "ID Card Number"),
                    controller: nic),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: mandatoryValidator,
                    decoration: InputDecoration(labelText: "Address"),
                    controller: address),
                SizedBox(height: 32),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            push(
                                context,
                                EnterAmount(
                                  heading: "Cash Pickup",
                                  sending: true,
                                  title: "${firstName.text} ${lastName.text}",
                                  subTitle: "${phoneNum.text}",
                                  icon: Icon(FontAwesomeIcons.user,
                                      color: Theme.of(context).primaryColor),
                                  onAmountEntered: (amount) =>
                                      sendForCashPickup(
                                          firstName.text,
                                          lastName.text,
                                          phoneNum.text,
                                          nic.text,
                                          address.text,
                                          amount),
                                ));
                          }
                        },
                        child: Text("Continue")),
                  )
                ]),
              ]),
            ),
          ),
        ));
  }

  Future<String> sendForCashPickup(String firstName, String lastName,
      String phoneNumber, String nic, String address, double amount) {
    push(
        context,
        TransactionReceipt(
            heading: "Cash Pickup",
            from: "Gafa Wallet",
            to: "$firstName $lastName",
            amount: amount,
            additionalInfo: {
              "Phone Number": phoneNumber,
              "Address": address,
              "ID Card": nic,
            },
            onPinEntered: (pin) async {
              final resp = await kio.post<VoidResp>(
                  token: await context.read<AuthState>().token,
                  path: "/api/v1/CashPickUp",
                  respGen: (json) => VoidResp.fromJson(json),
                  bodyParam: () => {
                        "phoneNumber": phoneNumber,
                        "receiverName": "$firstName $lastName",
                        "nationalCardNumber": nic,
                        "amount": amount,
                        "pin": pin
                      });
              if (resp.hasError) {
                return resp.error.errorMessage;
              } else {
                print(resp.response.json);
                push(
                    context,
                    TransferSuccess(
                      message: "You sent $amount to $firstName $lastName",
                    ));
                return null;
              }
            }));
    return Future.value(null);
  }
}
