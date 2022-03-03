import 'package:flutter/material.dart';
import 'package:gafamoney/model/gafa_user_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:kio/connection/hussain.dart';
import 'package:provider/provider.dart';

class RecentContactsView extends StatefulWidget {
  final RecentContactsLine line;
  final void Function(String) phoneSelected;

  RecentContactsView({Key key, RecentContactsLine line, this.phoneSelected})
      : line = line ?? RecentContactsLine(),
        super(key: key);

  @override
  _RecentContactsViewState createState() => _RecentContactsViewState();
}

class _RecentContactsViewState extends State<RecentContactsView> {
  List<GafaUserModel> users;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    final resp = await widget.line
        .getRecentContacts(await context.read<AuthState>().token);
    if (resp.hasError) {
      snack(context, resp.error.errorMessage);
    } else {
      setState(() {
        users = resp.response.users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return users == null
        ? CircularProgressIndicator()
        : users.length == 0
            ? Text("No recent contacts found")
            : Column(
                children: ListTile.divideTiles(
                  tiles: users.map((e) => getRecentContactTile(e)).toList(),
                  context: context,
                ).toList(),
              );
  }

  Widget getRecentContactTile(GafaUserModel user) {
    return ListTile(
      onTap: () => widget.phoneSelected(user.phoneNumber),
      title: Text(user.name),
      subtitle: Text(user.phoneNumber),
      leading: Image.network(
        Hussain.prefixBase(onUrl: user.image),
        errorBuilder: (c, o, w) =>
            Icon(Icons.error, color: Theme.of(context).errorColor),
      ),
    );
  }
}
