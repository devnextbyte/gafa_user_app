import 'package:flutter/material.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/payment/company_pay.dart';
import 'package:gafamoney/view/dashboard/payment/insurance_list.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:kio/connection/hussain.dart';
import 'package:provider/provider.dart';

class CompanyListView extends StatelessWidget {
  final bool billPayment;
  final CompanyListLine line;

  CompanyListView({
    Key key,
    @required this.billPayment,
    CompanyListLine line,
  })  : this.line = line ?? CompanyListLine(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(
          billPayment ? "Bills / Recharge" : "Airtime Purchase",
        ),
        body: _CompanyListViewBody(billPayment, line));
  }
}

class _CompanyListViewBody extends StatefulWidget {
  final bool billPayment;
  final CompanyListLine line;

  _CompanyListViewBody(this.billPayment, CompanyListLine line)
      : this.line = line ?? CompanyListLine();

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
    final token = await context.read<AuthState>().token;
    final resp = await widget.line.getCompaniesList(token);
    if (resp.hasError) {
      print("${resp.error.errorMessage}after");
      setState(() {
        companies = [];
      });
      snack(context, resp.error.errorMessage);
    } else {
      setState(() {
        companies = widget.billPayment
            ? resp.response.getBillPaymentCompanies()
            : resp.response.getAirtimeTopUpCompanies();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: companies == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: List.generate(
                    widget.billPayment
                        ? companies.length + 1
                        : companies.length,
                    (e) => widget.billPayment && e == companies.length
                        ? getInsuaranceTile(context)
                        : getCompanyTile(context, companies[e])).toList(),
              ));
  }

  Widget getInsuaranceTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              return push(context, InsuranceListView());
            },
            contentPadding: EdgeInsets.all(16),
            tileColor: Colors.grey.shade100,
            leading: Image.asset(
              "assets/images/insuarance.png",
              width: 64,
              errorBuilder: (c, o, s) => Icon(
                Icons.error,
                color: Theme.of(context).errorColor,
              ),
            ),
            title: Text("Insurance"),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor),
          ),
          Divider(color: Colors.transparent),
        ],
      ),
    );
  }

  Widget getCompanyTile(BuildContext context, CompanyModel company) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            onTap: () => push(
                context,
                CompanyPay(
                  billPayment: widget.billPayment,
                  companies: companies,
                  initailSelectedCompany: company,
                )),
            contentPadding: EdgeInsets.all(16),
            tileColor: Colors.grey.shade100,
            leading: Image.network(
              Hussain.prefixBase(onUrl: company.imageUrl),
              width: 64,
              errorBuilder: (c, o, s) => Icon(
                Icons.error,
                color: Theme.of(context).errorColor,
              ),
            ),
            title: Text(company.name),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor),
          ),
          Divider(color: Colors.transparent),
        ],
      ),
    );
  }
}
