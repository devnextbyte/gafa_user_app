import 'package:flutter/material.dart';
import 'package:gafamoney/model/add_money_model.dart';
import 'package:gafamoney/model/card_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/add_money/card/add_card.dart';
import 'package:gafamoney/view/dashboard/payment/enter_amount.dart';
import 'package:gafamoney/view/dashboard/payment/transaction_recipt.dart';
import 'package:gafamoney/view/dashboard/payment/transfer_success.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/param/hussain_list_parameter.dart';
import 'package:provider/provider.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<CardModel> cards = [];
  bool loading;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  void loadCards() async {
    setState(() {
      loading = true;
    });
    final resp = await requestCards.send(
      token: await context.read<AuthState>().token,
      parameters: HussainListParam(),
    );

    if (resp.hasError) {
      snack(context, resp.error.errorMessage);
    } else {
      setState(() {
        cards = resp.response.data;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(title: "Credit / Card", showBackButton: true),
          SizedBox(height: 24),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: cards
                        .map((card) => getDebitCard(context, card))
                        .toList(),
                  ),
          ),
          SizedBox(height: 24),
          getAddCardButton(context),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget getAddCardButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        onTap: () async {
          await push(context, AddCard());
          loadCards();
        },
        leading: Icon(Icons.add_circle_outline,
            size: 32, color: Theme.of(context).primaryColor),
        title: Text(
          "Add a new card",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget getDebitCard(BuildContext context, CardModel card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () => push(
          context,
          EnterAmount(
            heading: "Credit / Debit Card",
            sending: false,

            icon: Image.asset("assets/images/credit_card.png"),
            title: card.name,
            subTitle: "**** **** **** ${card.lastDigits}",
            onAmountEntered: (amount) => confirmTransaction(
              context,
              card.id,
              amount,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Card",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white)),
                  Text("**** **** **** ${card.lastDigits}",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white)),
                ],
              ),
              SizedBox(height: 40),
              Image.asset("assets/images/sim_card.png", width: 56),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(card.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white)),
                  Image.asset("assets/images/master_card.png", width: 48)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> confirmTransaction(BuildContext context, int cardId, double amount) {
    push(
        context,
        TransactionReceipt(
          heading: "Credit / Debit Card",
          amount: amount,
          from: "Credit Card",
          to: "Gafa Wallet",
          addTransaction: true,
          onPinEntered: (pin) => addMoney(context, cardId, amount, pin),
        ));
    return null;
  }

  Future<String> addMoney(
    BuildContext context,
    int cardId,
    double amount,
    String pin,
  ) async {
    final resp = await requestAddMoney.send(
      parameters: AddMoneyParam(amount: amount, cardId: cardId, pin: pin),
      token: await context.read<AuthState>().token,
    );
    if (resp.isSuccess) {
      push(
          context,
          TransferSuccess(
            message:
                "You topped up ${amount.toStringAsFixed(2)} to your Gafa wallet",
          ));
      return null;
    } else {
      return resp.error.errorMessage;
    }
  }
}
