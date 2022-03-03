import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:provider/provider.dart';

class EnterAmount extends StatefulWidget {
  final String subTitle;
  final String title;
  final Widget icon;
  final String heading;
  final Future<String> Function(double) onAmountEntered;
  final bool sending;

  const EnterAmount({
    @required this.heading,
    @required this.title,
    @required this.subTitle,
    @required this.icon,
    @required this.onAmountEntered,
    @required this.sending,
  });

  @override
  _EnterAmountState createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  String enteredAmount = "";
  bool loading = false;
  bool insufficentBalance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.heading),
      body: Builder(
        builder: (context) => Column(children: [
          SizedBox(height: 64),
          getInfo(context),
          SizedBox(height: 64),
          getAmount(context),
          Expanded(child: getKeyboard(context)),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Expanded(
                  child: loading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (enteredAmount.isEmpty ||
                                enteredAmount.characters.first == ".") {
                              snack(context, "Enter a correct amount");
                              return;
                            }
                            final amount = double.parse(enteredAmount);
                            if (amount == 0) {
                              snack(context, "Enter a correct amount");
                              return;
                            }
                            print("sending ${widget.sending}");
                            if (widget.sending &&
                                amount > context.read<AuthState>().balance) {
                              setState(() {
                                insufficentBalance = true;
                              });
                              return;
                            } else {
                              setState(() {
                                insufficentBalance = false;
                              });
                            }
                            setState(() {
                              loading = true;
                            });
                            final resp = await widget.onAmountEntered(amount);
                            setState(() {
                              loading = false;
                            });

                            if (resp != null) {
                              snack(context, resp);
                            }
                          },
                          child: Text("Continue"),
                        ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget getKeyboard(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.all(32),
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 3,
        children: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '.',
          '0',
          'b',
        ].map((e) => getGridButton(context, e)).toList());
  }

  Widget getGridButton(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          if (text == "." && enteredAmount.contains(".")) {
            return;
          } else if (text == "b") {
            if (enteredAmount.length > 0)
              enteredAmount =
                  enteredAmount.substring(0, enteredAmount.length - 1);
          } else {
            enteredAmount = enteredAmount + text;
          }
        });
      },
      child: Center(
        child: text == 'b'
            ? Image.asset(
                "assets/images/keyboard_back.png",
                width: 32,
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.headline6,
              ),
      ),
    );
  }

  Widget getAmount(BuildContext context) {
    return Column(children: [
      Text(
        "Enter Amount",
        style: TextStyle(
            color: insufficentBalance ? Colors.red.shade900 : Colors.black),
      ),
      Text(
        "CFA $enteredAmount",
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(color: Theme.of(context).primaryColor),
      ),
      insufficentBalance
          ? Text(
              "Insufficient balance, your balance is CFA ${context.watch<AuthState>().balance}",
              style: TextStyle(color: Colors.red.shade900),
            )
          : SizedBox(),
    ]);
  }

  // Widget getCardInfo(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 32.0),
  //     child: ListTile(
  //       tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
  //       contentPadding: EdgeInsets.all(8),
  //       title: Text(widget.card.name,
  //           style: TextStyle(color: Theme.of(context).primaryColor)),
  //       subtitle: Text("**** **** **** ${widget.card.lastDigits}",
  //           style: TextStyle(color: Theme.of(context).primaryColor)),
  //       leading: Container(
  //         width: 48,
  //         height: 48,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Image.asset("assets/images/credit_card.png"),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget getBankInfo(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 32.0),
  //     child: ListTile(
  //       tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
  //       contentPadding: EdgeInsets.all(8),
  //       title: Text(widget.bank.name,
  //           style: TextStyle(color: Theme.of(context).primaryColor)),
  //       subtitle: Text(widget.subTitle,
  //           style: TextStyle(color: Theme.of(context).primaryColor)),
  //       leading: Container(
  //         width: 48,
  //         height: 48,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Image.asset("assets/images/bank.png"),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget getInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        contentPadding: EdgeInsets.all(8),
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).primaryColor)),
        subtitle: Text(widget.subTitle,
            style: TextStyle(color: Theme.of(context).primaryColor)),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.icon,
          ),
        ),
      ),
    );
  }

// Widget getPhoneInfo(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 32.0),
//     child: ListTile(
//       tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
//       contentPadding: EdgeInsets.all(8),
//       title: Text(widget.subTitle,
//           style: TextStyle(color: Theme.of(context).primaryColor)),
//       // subtitle: Text("123456781",
//       //     style: TextStyle(color: Theme.of(context).primaryColor)),
//       leading: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Icon(FontAwesomeIcons.user,
//               color: Theme.of(context).primaryColor),
//         ),
//       ),
//     ),
//   );
// }
}
