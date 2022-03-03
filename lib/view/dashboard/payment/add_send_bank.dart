import 'package:flutter/material.dart';
import 'package:gafamoney/model/send_money_model.dart';
import 'package:gafamoney/model/withdraw.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:provider/provider.dart';

class AddSendBank extends StatefulWidget {
  final name = TextEditingController();
  final iban = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final bool isAddMoney;

  AddSendBank.forAddMoney() : isAddMoney = true;

  AddSendBank.forSendMoney() : isAddMoney = false;

  @override
  _AddSendBankState createState() => _AddSendBankState();
}

class _AddSendBankState extends State<AddSendBank> {
  List<BankModel> banks;
  BankModel selectedBank;

  @override
  void initState() {
    super.initState();
    loadBanks();
  }

  void loadBanks() async {
    final resp = await requestBankList.send(
      parameters: HussainListParam(),
      token: await context.read<AuthState>().token,
    );
    if (resp.isSuccess) {
      print(resp.response.json);
      setState(() {
        banks = resp.response.banks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(title: "Bank Account", showBackButton: true),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  banks == null
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<BankModel>(
                          validator: (b) => b == null ? "Select Bank" : null,
                          isExpanded: true,
                          value: selectedBank,
                          items: banks
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.name),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedBank = v)),
                  TextFormField(
                      validator: mandatoryValidator,
                      controller: widget.iban,
                      decoration: InputDecoration(labelText: "IBAN")),
                  TextFormField(
                      controller: widget.name,
                      validator: mandatoryValidator,
                      decoration: InputDecoration(labelText: "Name")),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.formKey.currentState.validate()) {
                              push(
                                  context,
                                  EnterAmount(
                                    heading: widget.isAddMoney
                                        ? "Add Money"
                                        : "Send to Bank",
                                    title: selectedBank.name,
                                    sending: widget.isAddMoney
                                        ? false
                                        : true,
                                    subTitle: widget.name.text,
                                    icon: Image.asset("assets/images/bank.png"),
                                    onAmountEntered: (amount) => amountEntered(
                                        context,
                                        widget.iban.text,
                                        widget.name.text,
                                        amount,
                                        selectedBank),
                                  ));
                            }
                          },
                          child: Text("Continue"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> amountEntered(BuildContext context, String bankAccountNumber,
      String accountName, double amount, BankModel selectedBank) async {
    push(
      context,
      TransactionReceipt(
        heading: "Add from Bank",
        from: bankAccountNumber,
        to: "Gafa Wallet",
        amount: amount,
        addTransaction: true,
        onPinEntered: (pin) => widget.isAddMoney
            ? addMoney(context, bankAccountNumber, amount, pin, accountName,
                selectedBank)
            : sendMoney(context, bankAccountNumber, amount, pin, selectedBank),
      ),
    );
    return null;
  }

  Future<String> addMoney(
    BuildContext context,
    String bankAccountNum,
    double amount,
    String pin,
    String accountName,
    BankModel selectedBank,
  ) async {
    final resp = await requestAddByBank.send(
      token: await context.read<AuthState>().token,
      parameters: CreditBankParam(
        pin: pin,
        amount: amount,
        accountName: accountName,
        accountNo: bankAccountNum,
        bankId: selectedBank.id,
      ),
    );
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message:
                "You added ${amount.toStringAsFixed(2)} from $bankAccountNum",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }

  Future<String> sendMoney(
    BuildContext context,
    String bankAccountNum,
    double amount,
    String pin,
    BankModel selectedBank,
  ) async {
    final resp = await requestWithdraw.send(
      token: await context.read<AuthState>().token,
      parameters: WithdrawParam(
          accountNumber: bankAccountNum,
          amount: amount,
          bankCode: selectedBank.swiftCode,
          branchId: 0,
          name: bankAccountNum,
          pin: pin),
    );
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message: "You sent ${amount.toStringAsFixed(2)} to $bankAccountNum",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }
}
