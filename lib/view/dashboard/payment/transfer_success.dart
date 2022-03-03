import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:provider/provider.dart';

class TransferSuccess extends StatefulWidget {
  final String message;

  const TransferSuccess({Key key, this.message}) : super(key: key);

  @override
  _TransferSuccessState createState() => _TransferSuccessState();
}

class _TransferSuccessState extends State<TransferSuccess> {
  @override
  void initState() {
    super.initState();
    context.read<AuthState>().loadBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/transfer_success.png",
            ),
            Text(
              "Your Transaction is successful 👍🏾",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      popToMain(context);
                      // push(context, Home());
                    },
                    child: Text("Done, Thank You"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
