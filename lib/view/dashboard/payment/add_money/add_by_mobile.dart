import 'package:flutter/material.dart';
import 'package:gafamoney/view/reusable/flag_widget.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';

class AddByAgent extends StatefulWidget {
  @override
  _AddByAgentState createState() => _AddByAgentState();
}

class _AddByAgentState extends State<AddByAgent> {
  String agent = "Select Partner/Agent";
  final countryCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(title: "Mobile Banking", showBackButton: true),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButton<String>(
                    isExpanded: true,
                    value: agent,
                    items: ["Select Partner/Agent", "Partner One", "Agent Two"]
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => agent = v)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlagWidget(controller: countryCode),
                    Expanded(
                      child: TextField(
                        key: Key("phone_input"),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 0)),
                      ),
                    ),
                    Image.asset("assets/images/my_contacts.png", width: 32),
                  ],
                ),
                Divider(thickness: 1.5, height: 0),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Frequent Contact",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () {},
                  // contentPadding: EdgeInsets.all(4),
                  tileColor: Colors.grey.shade100,
                  leading: Image.asset("assets/images/person.png"),
                  title: Text("Olabode Felix"),
                  subtitle: Text("+2210945623432"),
                ),
                SizedBox(height: 32),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // return push(context, EnterAmount());
                      },
                      child: Text("Continue"),
                    ),
                  )
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
