import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/add_money/card/card_list.dart';
import 'package:gafamoney/view/dashboard/payment/add_send_bank.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class AddMoneyOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(title: "Add Money", showBackButton: true),
          SizedBox(height: 48),
          getButtons(context)
        ],
      ),
    );
  }

  Widget getButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getButton(
            context,
            title: "Credit / Debit Card",
            bigIcon: "assets/images/credit_card.png",
            smallIcon: "assets/images/credit_card_small.png",
            subtitle: "Add money with your card",
            onTap: () => push(context, CardList()),
          ),
          // SizedBox(height: 16),
          // getButton(
          //   context,
          //   title: "Mobile Banking",
          //   bigIcon: "assets/images/mobile.png",
          //   smallIcon: "assets/images/mobile_small.png",
          //   subtitle: "Add money from mobile banking",
          //   onTap: () => push(context, AddByAgent()),
          // ),
          SizedBox(height: 16),
          getButton(
            context,
            title: "Bank Account",
            bigIcon: "assets/images/bank.png",
            smallIcon: "assets/images/bank_small.png",
            subtitle: "Add money from your account",
            onTap: () => push(context, AddSendBank.forAddMoney()),
          ),
        ],
      ),
    );
  }

  Widget getButton(
    BuildContext context, {
    @required String title,
    @required String subtitle,
    @required String smallIcon,
    @required String bigIcon,
    @required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          padding: EdgeInsets.all(24),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(smallIcon),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: Theme.of(context).primaryColor))
                ],
              ),
            ),
            Image.asset(bigIcon, width: 60)
          ]),
        ),
      ),
    );
  }
}
