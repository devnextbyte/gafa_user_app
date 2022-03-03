import 'package:flutter/material.dart';
import 'package:gafamoney/model/merchant_model.dart';
import 'package:gafamoney/model/send_money_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:kio/kio.dart';
import 'package:provider/provider.dart';
// import 'package:qrcode_reader/qrcode_reader.dart';

class Merchant extends StatefulWidget {
  @override
  _MerchantState createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  final _key = GlobalKey<FormState>();
  final merchant = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _key,
          child: Column(
              children: [
                // getQrBox(context),
                // getOr(context),
                TextFormField(
                  validator: mandatoryValidator,
                  controller: merchant,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Merchant Number",
                  ),
                ),
                SizedBox(height: 40),
                Row(children: [
                  Builder(
                    builder: (context) => loading
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_key.currentState.validate()) {
                                  getMerchantAndSend(
                                      context, merchant.text);
                                }
                              },
                              child: Text("Continue"),
                            ),
                          ),
                  )
                ])
              ]),
        ));
  }

  Widget getQrBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        // String scanResult = await QRCodeReader().setTorchEnabled(true).scan();
        // if (scanResult != null && scanResult.isNotEmpty) {
        //   getMerchantAndSend(context, scanResult);
        // }
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3 * 2,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Image.asset("assets/images/qr_icon.png"),
          ),
          SizedBox(height: 32),
          Text("Tap to Scan QrCode",
              style: TextStyle(color: Theme.of(context).primaryColor))
        ],
      ),
    );
  }

  Widget getOr(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1.5)),
          SizedBox(width: 32),
          Text(
            "OR",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.grey),
          ),
          SizedBox(width: 32),
          Expanded(child: Divider(thickness: 1.5)),
        ],
      ),
    );
  }

  void getMerchantAndSend(BuildContext context, String merchantNumber) async {
    setState(() {
      loading = true;
    });
    final resp = await kio.get<MerchantModel>(
        respGen: (json) => MerchantModel.fromJson(json),
        path: "/api/v1/Merchant/ByNumber/$merchantNumber",
        token: await context.read<AuthState>().token);
    setState(() {
      loading = false;
    });
    if (resp.hasError) {
      snack(context, resp.error.errorMessage);
    } else {
      push(
          context,
          EnterAmount(
              heading: "Pay Merchant",
              title: resp.response.fullName,
              sending: true,
              subTitle: resp.response.tillNumber,
              icon:
                  Image.network(Hussain.prefixBase(onUrl: resp.response.image)),
              onAmountEntered: (amount) => push(
                  context,
                  TransactionReceipt(
                      heading: "Pay Merchant",
                      from: "Gafa Wallet",
                      to: resp.response.fullName,
                      amount: amount,
                      onPinEntered: (pin) => sendMoneyAction(
                          context,
                          resp.response.tillNumber,
                          resp.response.fullName,
                          amount,
                          pin)))));
    }
  }

  Future<String> sendMoneyAction(
    BuildContext context,
    String phoneNumber,
    String name,
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
            message: "You sent ${amount.toStringAsFixed(2)} to $name",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }
}
