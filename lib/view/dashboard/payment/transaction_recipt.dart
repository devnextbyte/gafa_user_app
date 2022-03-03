import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/gafa_bio.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/bio_button.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionReceipt extends StatefulWidget {
  final String heading;
  final String from;
  final String to;
  final double amount;
  final Map<String, String> additionalInfo;
  final Future<String> Function(String) onPinEntered;
  final bool addTransaction;

  TransactionReceipt({
    Key key,
    @required this.heading,
    @required this.from,
    @required this.to,
    @required this.amount,
    @required this.onPinEntered,
    this.addTransaction = false,
    Map<String, String> additionalInfo,
  })  : additionalInfo = additionalInfo ?? {},
        super(key: key);

  @override
  _TransactionReceiptState createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  final pin = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.heading),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(children: [
                  SizedBox(height: 40),
                  getBalanceCard(context),
                  SizedBox(height: 40),
                  Text(
                    "Transaction Review",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 40),
                  getDummyReview(context),
                  SizedBox(height: 40),
                  widget.amount > context.watch<AuthState>().balance &&
                          !widget.addTransaction
                      ? Text(
                          "Insufficent Balance",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Theme.of(context).errorColor),
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: mandatoryValidator,
                                  controller: pin,
                                  decoration: InputDecoration(
                                      labelText: "Enter transfer pin"),
                                  textInputAction: TextInputAction.done,
                                )),
                                BioButton(
                                  show: GafaBio.instance.isTransactionEnabled(),
                                  onPressed: (_, pin) => proceed(context, pin),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Builder(
                                  builder: (context) => loading
                                      ? CircularProgressIndicator()
                                      : Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (formKey.currentState
                                                  .validate()) {
                                                proceed(context, pin.text);
                                              }
                                            },
                                            child: Text("Confirm Transfer"),
                                          ),
                                        ),
                                )
                              ],
                            )
                          ],
                        )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void proceed(BuildContext context, String pin) async {
    setState(() {
      loading = true;
    });
    final err = await widget.onPinEntered(pin);
    setState(() {
      loading = false;
    });
    if (err != null) {
      snack(context, err);
    }
  }

  Widget getDummyReview(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor.withOpacity(0.05)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("From"),
          SizedBox(height: 8),
          Text("To"),
          SizedBox(height: 8),
          Text("Date"),
          SizedBox(height: 8),
          Column(
              children: widget.additionalInfo.keys
                  .map((e) => Column(
                        children: [Text(e), SizedBox(height: 8)],
                      ))
                  .toList()),
          Text("Amount"),
          SizedBox(height: 8),
          Text("Transaction Charges"),
          SizedBox(height: 8),
          Text(
            "Total",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(widget.from),
          SizedBox(height: 8),
          Text(widget.to),
          SizedBox(height: 8),
          Text(DateFormat.yMMMd().format(DateTime.now())),
          SizedBox(height: 8),
          Column(
              children: widget.additionalInfo.keys
                  .map((e) => Column(
                        children: [
                          Text(widget.additionalInfo[e]),
                          SizedBox(height: 8),
                        ],
                      ))
                  .toList()),
          Text("CFA ${widget.amount.toStringAsFixed(2)}"),
          SizedBox(height: 8),
          Text("CFA 0"),
          SizedBox(height: 8),
          Text(
            "CFA ${widget.amount.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
      ]),
    );
  }

  Widget getBalanceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor.withOpacity(0.1)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              "Your Gafa Wallet balance",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8),
            Text(
              "CFA ${context.watch<AuthState>().balance}",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Row(),
          ],
        ),
      ),
    );
  }
}
