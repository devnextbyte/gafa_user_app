import 'package:flutter/material.dart';
import 'package:gafamoney/utils/country_data.dart';
import 'package:gafamoney/utils/snippets.dart';

class FlagWidget extends StatefulWidget {
  final TextEditingController controller;

  const FlagWidget({Key key, @required this.controller}) : super(key: key);

  @override
  _FlagWidgetState createState() => _FlagWidgetState();
}

class _FlagWidgetState extends State<FlagWidget> {
  int flagIndex = 195;
  // int flagIndex = 167;

  @override
  void initState() {
    super.initState();
    widget.controller.text = codes[flagIndex]['dial_code'];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 16),
            Image.asset(
              'assets/images/flags/${codes[flagIndex]['code'].toString().toLowerCase()}.png',
              width: 30,
            ),
            Icon(Icons.expand_more),
            SizedBox(width: 8),
            Container(
              color: Theme.of(context).primaryColor,
              width: 2,
              height: 24,
            ),
            SizedBox(width: 8),
            Text(
              widget.controller.text,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      onTap: () =>
          Scaffold.of(context).showBottomSheet((context) => getFlagList()),
    );
  }

  Widget getFlagList() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 5 * 4,
        child: ListView.builder(
          key: Key("flag_list"),
          itemCount: codes.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/flags/${codes[index]['code'].toString().toLowerCase()}.png',
                      width: 30,
                    ),
                    Expanded(
                      child: Text(
                        codes[index]['name'],
                        key: Key(codes[index]['name']),
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(codes[index]['dial_code']),
                  ],
                ),
              ),
              onTap: () {
                setState(() => flagIndex = index);
                widget.controller.text = codes[index]['dial_code'];
                pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
