import 'package:flutter/material.dart';
import 'package:gafamoney/model/payment_request_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/activity/enter_pin.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:provider/provider.dart';

class RequestTab extends StatefulWidget {
  @override
  _RequestTabState createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  PaymentRequestResp requestResp;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  void loadRequests() async {
    final resp = await kio.get<PaymentRequestResp>(
        path: "/api/v1/Request",
        bodyParam: () => HussainListParam().toJson(),
        respGen: (json) => PaymentRequestResp.fromJson(json),
        token: await context.read<AuthState>().token);
    if (resp.hasError) {
      snack(context, resp.error.errorMessage);
    } else {
      setState(() {
        requestResp = resp.response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: requestResp == null
          ? Center(child: CircularProgressIndicator())
          : requestResp.data.isEmpty
              ? Center(child: Text("You have got no payment request"))
              : ListView(
                  children: ListTile.divideTiles(
                    color: Colors.white,
                    // context: context,
                    tiles: requestResp.data.map((e) => getListTile(context, e)),
                  ).toList(),
                ),
    );
  }

  Widget getListTile(BuildContext context, PaymentRequestItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // onTap: () => push(context, TransactionDetails()),
        tileColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(item.isSender ? Icons.arrow_upward : Icons.arrow_downward,
              color: item.isSender
                  ? Theme.of(context).primaryColor
                  : Colors.red.shade900),
        ),
        title: Text(item.isSender
            ? "CFA ${item.amount.toStringAsFixed(2)} is requested from ${item.receiver}"
            : "${item.sender} is requesting CFA ${item.amount.toStringAsFixed(2)}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              item.status == 1
                  ? "Accepted"
                  : item.status == 2
                      ? "Rejected"
                      : item.status == 3
                          ? "Canceled"
                          : "Waiting",
              style: TextStyle(
                  color: item.status == 1
                      ? Theme.of(context).primaryColor
                      : item.status == 2
                          ? Theme.of(context).errorColor
                          : item.status == 3
                              ? Colors.orange
                              : Colors.black),
            ),
            SizedBox(height: 8),
            Text(item.createdDate),
            SizedBox(height: 8),
            item.status == 0 && !item.isSender
                ? Row(children: [
                    Expanded(
                        child: RaisedButton(
                      onPressed: () async {
                        await push(context, EnterPin.forReject(request: item));
                        loadRequests();
                      },
                      child: Text("Reject"),
                      color: Colors.red.shade900,
                    )),
                    SizedBox(width: 16),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              await push(
                                  context, EnterPin.forAccept(request: item));
                              loadRequests();
                            },
                            child: Text("Accept"))),
                  ])
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
