import 'package:flutter/material.dart';
import 'package:gafamoney/model/payment_request_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:provider/provider.dart';

class EnterPin extends StatefulWidget {
  final PaymentRequestItemModel request;
  final bool forReject;

  EnterPin.forAccept({Key key, this.request})
      : forReject = false,
        super(key: key);

  EnterPin.forReject({Key key, this.request})
      : forReject = true,
        super(key: key);

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  String pin = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        HeaderBar(title: "Enter Pin", showBackButton: true),
        SizedBox(height: 64),
        getCardInfo(context),
        SizedBox(height: 64),
        getAmount(context),
        Expanded(child: getKeyboard(context)),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) => loading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (pin.length < 4) {
                              snack(context, "Enter Pin");
                              return;
                            }
                            setState(() {
                              loading = true;
                            });
                            final data = {
                              "requestId": widget.request.requestId,
                              "pin": pin,
                            };
                            final token = await context.read<AuthState>().token;
                            final resp = widget.forReject
                                ? await kio.put(
                                    path: "/api/v1/Request/reject",
                                    token: token,
                                    bodyParam: () => data)
                                : await kio.put(
                                    path: "/api/v1/Request/accept",
                                    token: token,
                                    bodyParam: () => data);
                            setState(() {
                              loading = false;
                            });
                            if (resp.isSuccess) {
                              if (widget.forReject) {
                                pop(context);
                              } else {
                                push(
                                    context,
                                    TransferSuccess(
                                      message:
                                          "You have successfully sent CFA ${widget.request.amount} to ${widget.request.sender}",
                                    ));
                              }
                            } else {
                              snack(context, resp.error.errorMessage);
                            }
                          },
                          child: Text("Continue"),
                        ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget getKeyboard(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.all(32),
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 3,
        children: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '.',
          '0',
          'b',
        ].map((e) => getGridButton(context, e)).toList());
  }

  Widget getGridButton(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        if (text != ".") {
          if (text == 'b') {
            setState(() {
              pin = "";
            });
          } else if (pin.length < 4) {
            setState(() {
              pin = pin += text;
            });
          }
        }
      },
      child: Center(
        child: text == 'b'
            ? Image.asset(
                "assets/images/keyboard_back.png",
                width: 32,
              )
            : text == "."
                ? Image.asset("assets/images/face_icon.png",
                    height: 24, width: 24, color: Colors.black)
                : Text(
                    text,
                    style: Theme.of(context).textTheme.headline6,
                  ),
      ),
    );
  }

  Widget getAmount(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 5 * 4,
      child: Column(children: [
        Text("Enter your transfer pin"),
        SizedBox(height: 16),
        getOtpInput(context),
      ]),
    );
  }

  Widget getOtpInput(BuildContext context) {
    int k = 8;
    final starik = Theme.of(context).textTheme.headline2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / k,
          height: MediaQuery.of(context).size.width / k,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey)),
          child: Center(child: Text(pin.length > 0 ? "*" : "", style: starik)),
        ),
        Container(
          width: MediaQuery.of(context).size.width / k,
          height: MediaQuery.of(context).size.width / k,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey)),
          child: Center(child: Text(pin.length > 1 ? "*" : "", style: starik)),
        ),
        Container(
          width: MediaQuery.of(context).size.width / k,
          height: MediaQuery.of(context).size.width / k,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey)),
          child: Center(child: Text(pin.length > 2 ? "*" : "", style: starik)),
        ),
        Container(
          width: MediaQuery.of(context).size.width / k,
          height: MediaQuery.of(context).size.width / k,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey)),
          child: Center(child: Text(pin.length > 3 ? "*" : "", style: starik)),
        ),
      ],
    );
  }

  Widget getCardInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        contentPadding: EdgeInsets.all(8),
        title: Text(widget.request.sender,
            style: TextStyle(color: Theme.of(context).primaryColor)),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset("assets/images/credit_card.png"),
          ),
        ),
      ),
    );
  }
}
