import 'package:flutter/material.dart';
import 'package:gafamoney/model/transaction_respp.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/activity/transaction_detail.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:provider/provider.dart';

class ActivityTab extends StatefulWidget {
  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  List<TransactionData> transactions;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() async {
    final param = HussainListParam().toJson();
    param['Type'] = -1;
    final resp = await kio.get(
        path: "/api/v1/Transaction",
        bodyParam: () => param,
        respGen: (json) => TransactionResponse.fromJson(json),
        token: await context.read<AuthState>().token);
    if (resp.isSuccess) {
      setState(() {
        transactions = resp.response.data;
      });
    } else {
      snack(context, resp.error.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: transactions == null
          ? Center(child: CircularProgressIndicator())
          : transactions.length == 0
              ? Center(child: Text("No recent transactions"))
              : ListView(
                  children: transactions
                      .map(
                        (e) => getListTile(context, e),
                      )
                      .toList(),
                ),
    );
  }

  Widget getListTile(BuildContext context, TransactionData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () => push(context, TransactionDetails(data: data)),
        tileColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              Icon(Icons.arrow_upward, color: Theme.of(context).primaryColor),
        ),
        title: Text(data.message),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.loadType,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(data.date.replaceAll(" ", "\n")),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "CFA ${data.amount}",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              "${data.toName}",
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
