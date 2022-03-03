import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';

PreferredSize getAppBar(String title, {bool showBack}) => PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: HeaderBar(title: title, showBackButton: showBack ?? true),
    );

class HeaderBar extends StatelessWidget {
  final bool showBackButton;
  final String title;
  final Widget trailing;

  const HeaderBar(
      {Key key,
      this.showBackButton = false,
      @required this.title,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+16),
      child: Column(
        children: [
          // SizedBox(height: 54),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: showBackButton
                      ? TextButton.icon(
                          onPressed: () => pop(context),
                          label: Text("Back"),
                          icon: Icon(Icons.arrow_back_ios_rounded),
                        )
                      : SizedBox(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: trailing ?? SizedBox()))
            ],
          ),
        ],
      ),
    );
  }
}
