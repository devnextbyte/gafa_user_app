import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/country_data.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/dashboard/merchant/merchant_main.dart';
import 'package:gafamoney/view/dashboard/payment/add_money/add_money_options.dart';
import 'package:gafamoney/view/dashboard/payment/company_list.dart';
import 'package:gafamoney/view/dashboard/payment/company_pay.dart';
import 'package:gafamoney/view/dashboard/payment/send_money/send_money_options.dart';
import 'package:gafamoney/view/dashboard/payment/user_send_or_request.dart';
import 'package:gafamoney/view/dashboard/scan/scan_to_pay_view.dart';
import 'package:gafamoney/view/profile/profile_main.dart';
import 'package:kio/kio.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final CompanyListLine line;

  Dashboard({Key key, CompanyListLine line})
      : this.line = line ?? CompanyListLine(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _DashboardBody(
        line: line,
      ),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  final CompanyListLine line;

  const _DashboardBody({Key key, this.line}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<_DashboardBody> {
  bool showBalance = false;
  String companiesErrMsg;
  CompanyListResp compResp;

  @override
  void initState() {
    super.initState();
    loadBalance();
    loadCompanies();
  }

  void loadBalance() async {
    final err = await context.read<AuthState>().loadBalance();
    if (err != null) {
      snack(context, err, duration: Duration(minutes: 1));
    }
  }

  void loadCompanies() async {
    final resp = await widget.line
        .getCompaniesList(await context.read<AuthState>().token);
    if (resp.hasError) {
      setState(() {
        companiesErrMsg = resp.error.errorMessage;
      });
    } else {
      setState(() {
        compResp = resp.response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 40 * 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: [
              SizedBox(height: 48),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Image.asset(
                  "assets/images/logo_small.png",
                  width: 32,
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () => push(context, ProfileMain()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            Hussain.prefixBase(
                                onUrl: context.watch<AuthState>().image),
                            width: 32,
                            fit: BoxFit.fill,
                            height: 32,
                            errorBuilder: (a, b, c) => Icon(Icons.error_outline,
                                color: Theme.of(context).errorColor),
                          ),
                        ),
                      ),
                    ),
                    context.watch<AuthState>().notifications == 0
                        ? SizedBox()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                  child: Text(
                                      "${context.watch<AuthState>().notifications}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: Colors.white))),
                            )),
                  ],
                ),
              ]),
              SizedBox(height: 48),
              getBalanceCard(context),
              // SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 16),
                    getActions(context),
                    SizedBox(height: 16),
                    compResp == null
                        ? CircularProgressIndicator()
                        : companiesErrMsg != null
                            ? Text(
                                companiesErrMsg,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Theme.of(context).errorColor),
                              )
                            : Column(
                                key: Key("companies"),
                                children: [
                                  getService(context, true,
                                      compResp.getBillPaymentCompanies()),
                                  SizedBox(height: 16),
                                  getService(context, false,
                                      compResp.getAirtimeTopUpCompanies()),
                                  SizedBox(height: 16),
                                ],
                              ),
                  ]),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget getBalanceCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "My Balance",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Image.asset(
                'assets/images/flags/${codes[195]['code'].toString().toLowerCase()}.png',
                width: 30,
              ),
              Text(
                "CFA ${showBalance ? context.watch<AuthState>().balance.toStringAsFixed(2) : "*****"}",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              IconButton(
                onPressed: () => setState(() => showBalance = !showBalance),
                icon: Icon(
                  showBalance
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ]),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton.icon(
                onPressed: () => push(context, AddMoneyOptions()),
                label: Text("Add Money"),
                icon: Icon(FontAwesomeIcons.plusCircle, size: 16),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  push(context, ScanToPayView());
                },
                label: Text("Scan to Pay"),
                icon: Icon(FontAwesomeIcons.qrcode, size: 16),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget getActions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          InkWell(
            onTap: () => push(context, SendMoneyOptions()),
            child: Column(children: [
              Image.asset("assets/images/dash_send.png",
                  width: 64, fit: BoxFit.fill),
              SizedBox(height: 8),
              Text("Send Money"),
            ]),
          ),
          InkWell(
            onTap: () {
              return push(
                context,
                UserSendOrRequest.forRequest(title: "Request Money"),
              );
            },
            child: Column(children: [
              Image.asset("assets/images/dash_request.png",
                  width: 64, fit: BoxFit.fill),
              SizedBox(height: 8),
              Text("Request Money"),
            ]),
          ),
          InkWell(
            onTap: () => push(context, MerchantMain()),
            child: Column(children: [
              Image.asset("assets/images/dash_merchant.png",
                  width: 64, fit: BoxFit.fill),
              SizedBox(height: 8),
              Text("Merchant"),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget getService(
    BuildContext context,
    bool billPayment,
    List<CompanyModel> list,
  ) {
    return Card(
      key: Key(billPayment ? "Bill / Recharge" : "Airtime Purchase"),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              billPayment ? "Bill / Recharge" : "Airtime Purchase",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  list.length + 1,
                  (index) => index == list.length
                      ? getMoreButton(billPayment)
                      : getCompanyCard(billPayment, list, list[index])),
            ),
          ),
        ]),
      ),
    );
  }

  Widget getMoreButton(bool billPayment) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () {
          push(context, CompanyListView(billPayment: billPayment));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.more_horiz, color: Theme.of(context).primaryColor),
            Text("More Services",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Theme.of(context).primaryColor)),
          ]),
        ),
      ),
    );
  }

  Widget getCompanyCard(
      bool billPayment, List<CompanyModel> list, CompanyModel company) {
    return Container(
      height: 64,
      key: Key("${company.name}${company.companyId}"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: EdgeInsets.only(right: 8),
      width: MediaQuery.of(context).size.width / 5,
      child: InkWell(
        onTap: () => push(
            context,
            CompanyPay(
              billPayment: billPayment,
              companies: list,
              initailSelectedCompany: company,
            )),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Image.network(
              Hussain.prefixBase(onUrl: company.imageUrl),
              errorBuilder: (c, o, t) => SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
