import 'package:flutter/material.dart';
import 'package:gafamoney/model/transaction_respp.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionData data;

  const TransactionDetails({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Transaction Receipt"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getTransactionReview(context),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () => pop(context), child: Text("OK")),
              )
            ])
          ],
        ),
      ),
    );
  }

  Widget getTransactionReview(BuildContext context) {
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
          Text("Amount"),
          SizedBox(height: 8),
          Text("Transaction Charges"),
          SizedBox(height: 8),
          Text(
            "Fee",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text("${data.fromName}"),
          SizedBox(height: 8),
          Text("${data.toName}"),
          SizedBox(height: 8),
          Text("${data.date}"),
          SizedBox(height: 8),
          Text("CFA ${data.amount}"),
          SizedBox(height: 8),
          Text("CFA ${data.fee + data.tax}"),
          SizedBox(height: 8),
          Text(
            "CFA ${data.net}",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
      ]),
    );
  }
}
