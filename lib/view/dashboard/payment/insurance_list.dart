import 'package:flutter/material.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/repo/insurance_line.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/company_pay.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/hussain.dart';
import 'package:provider/provider.dart';

class InsuranceListView extends StatelessWidget {
  final InsuranceLine line;

  InsuranceListView() : this.line = InsuranceLine();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
          "Insurance",
        ),
        body: _CompanyListViewBody(line));
  }
}

class _CompanyListViewBody extends StatefulWidget {
  final InsuranceLine line;

  _CompanyListViewBody(InsuranceLine line)
      : this.line = line ?? InsuranceLine();

  @override
  _CompanyListViewState createState() => _CompanyListViewState();
}

class _CompanyListViewState extends State<_CompanyListViewBody> {
  List<CompanyModel> companies;

  @override
  void initState() {
    super.initState();
    loadCompanies();
  }

  void loadCompanies() async {
    setState(() {
      companies = widget.line.getInsuranceCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: companies == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: List.generate(companies.length,
                    (e) => getInsuaranceTile(context, companies[e])).toList(),
              ));
  }

  Widget getInsuaranceTile(BuildContext context, CompanyModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.all(16),
            tileColor: Colors.grey.shade100,
            leading: Image.asset(
              model.imageUrl,
              width: 64,
              errorBuilder: (c, o, s) => Icon(
                Icons.error,
                color: Theme.of(context).errorColor,
              ),
            ),
            title: Text(model.name),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor),
          ),
          Divider(color: Colors.transparent),
        ],
      ),
    );
  }
}
