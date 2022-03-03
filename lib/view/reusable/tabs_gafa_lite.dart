import 'package:flutter/material.dart';

class TabsGafaLite extends StatefulWidget {
  final List<String> tabs;
  final void Function(int, String) onTabChange;

  const TabsGafaLite({Key key, @required this.tabs, @required this.onTabChange})
      : super(key: key);

  @override
  _TabsGafaLiteState createState() => _TabsGafaLiteState();
}

class _TabsGafaLiteState extends State<TabsGafaLite> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        // border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: widget.tabs.map((e) => Expanded(child: getTab(e))).toList(),
      ),
    );
  }

  Widget getTab(String e) {
    return widget.tabs.indexOf(e) == selectedTab
        ? getSelectedTab(e)
        : getUnSelectedTab(e);
  }

  Widget getSelectedTab(String e) {
    return RaisedButton(
      color: Colors.white,
      textColor: Theme.of(context).primaryColor,
      onPressed: () {
        widget.onTabChange(selectedTab, e);
      },
      child: Text(e),
    );
  }

  Widget getUnSelectedTab(String e) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedTab = widget.tabs.indexOf(e);
        });
        widget.onTabChange(selectedTab, e);
      },
      child: Text(e),
    );
  }
}
