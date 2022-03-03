import 'package:flutter/material.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:provider/provider.dart';

class CompanyPay extends StatefulWidget {
  final List<CompanyModel> companies;
  final CompanyModel initailSelectedCompany;
  final bool billPayment;
  final formKey = GlobalKey<FormState>();
  final meterNum = TextEditingController();
  final amount = TextEditingController();

  CompanyPay({
    Key key,
    @required this.companies,
    @required this.initailSelectedCompany,
    @required this.billPayment,
  }) : super(key: key);

  @override
  _CompanyPayState createState() =>
      _CompanyPayState()..selectedCompany = initailSelectedCompany;
}

class _CompanyPayState extends State<CompanyPay> {
  CompanyModel selectedCompany;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: widget.formKey,
        child: Column(
          children: [
            HeaderBar(
              title:
                  widget.billPayment ? "Bills / Recharge" : "Airtime Purchase",
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<CompanyModel>(
                      isExpanded: true,
                      value: selectedCompany,
                      items: widget.companies
                          .map((e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => selectedCompany = v)),
                  TextFormField(
                      validator: mandatoryValidator,
                      controller: widget.meterNum,
                      decoration: InputDecoration(labelText: "Meter Number")),
                  TextFormField(
                    validator: mandatoryValidator,
                    controller: widget.amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Amount"),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.formKey.currentState.validate()) {
                              push(
                                  context,
                                  TransactionReceipt(
                                      to: widget.meterNum.text,
                                      from: "Gafa Wallet",
                                      onPinEntered: (pin) => sendCompanyMoney(
                                          context,
                                          widget.meterNum.text,
                                          selectedCompany.companyId,
                                          double.parse(widget.amount.text),
                                          pin),
                                      amount: double.parse(widget.amount.text),
                                      heading: widget.billPayment
                                          ? "Bills / Recharge"
                                          : "Airtime Purchase"));
                            }
                          },
                          child: Text("Continue"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> sendCompanyMoney(BuildContext context, String phoneNumber,
      int companyId, double amount, String pin) async {
    final resp = await CompanyListLine().requestPayBill.send(
        parameters: PayBillParam(
          billNo: phoneNumber,
          referenceNo: phoneNumber,
          companyId: companyId,
          amount: amount,
          pin: pin,
        ),
        token: await context.read<AuthState>().token);

    if (resp.hasError) {
      return resp.error.errorMessage;
    } else {
      context.read<AuthState>().loadBalance();
      push(
          context,
          TransferSuccess(
              message: "You have sucessfully paid bill $phoneNumber"));
      return null;
    }
  }
}
