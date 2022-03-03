import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/add_send_bank.dart';
import 'package:gafamoney/view/dashboard/payment/send_money/send_cash_pickup.dart';
import 'package:gafamoney/view/dashboard/payment/user_send_or_request.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class SendMoneyOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(title: "Send Money", showBackButton: true),
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
            title: "Gafa Money",
            bigIcon: "assets/images/gafa_sack.png",
            smallIcon: "assets/images/gafa_sack.png",
            subtitle: "Send money to other Gafa Account",
            onTap: () => push(context, UserSendOrRequest.forSend(title: "Send Money")),
          ),
          SizedBox(height: 16),
          getButton(
            context,
            title: "Cash Pick-Up",
            bigIcon: "assets/images/cash.png",
            smallIcon: "assets/images/cash.png",
            subtitle: "Send money from pick-up",
            onTap: () => push(context, SendCashPickup()),
          ),
          SizedBox(height: 16),
          getButton(
            context,
            title: "Bank Account",
            bigIcon: "assets/images/bank.png",
            smallIcon: "assets/images/bank_small.png",
            subtitle: "Add money from your account",
            onTap: () => push(context, AddSendBank.forSendMoney()),
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
