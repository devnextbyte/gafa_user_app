import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/view/dashboard/payment/company_list.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../dummy/companies_dummy_data.dart';
import '../reusable/mock_auth.dart';

class MockCompanyListLine extends Mock implements CompanyListLine {}

void main() {

  final cllSucc = MockCompanyListLine();
  when(cllSucc.getCompaniesList("dummy")).thenAnswer(
    (realInvocation) async => HussainResp.fromSuccess(
        statusCode: 200,
        response: CompanyListResp.fromJson(
            CompaniesDummyData.instance.getCompaniesListResp)),
  );

  group("Test Companies List", () {
    testWidgets("Labels and loading", (tester) async {
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
              value: MockAuthState(),
              builder: (context, widget) =>
                  CompanyListView(billPayment: true, line: cllSucc)),
        ),
      );
      expect(find.text("Bills / Recharge"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    group("List loaded successfully", () {
      testWidgets("With bill payment", (tester) async {
        await tester.pumpWidget(
          GafaMoneyApp(
            home: ChangeNotifierProvider<AuthState>.value(
                value: MockAuthState(),
                builder: (context, widget) =>
                    CompanyListView(billPayment: true, line: cllSucc)),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.text("Bill Payment"), findsOneWidget);
        expect(find.text("Air Time Top Up Company"), findsNothing);
      });

      testWidgets("With airtime", (tester) async {
        await tester.pumpWidget(
          GafaMoneyApp(
            home: ChangeNotifierProvider<AuthState>.value(
                value: MockAuthState(),
                builder: (context, widget) =>
                    CompanyListView(billPayment: false, line: cllSucc)),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.text("Bill Payment"), findsNothing);
        expect(find.text("Air Time Top Up Company"), findsOneWidget);
      });
    });

    testWidgets("Error on loading list", (tester) async {
      final cll = MockCompanyListLine();
      when(cll.getCompaniesList("dummy")).thenAnswer(
        (realInvocation) async => HussainResp.fromErrMsg("Server Error"),
      );
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
              value: MockAuthState(),
              builder: (context, widget) =>
                  CompanyListView(billPayment: false, line: cll)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.widgetWithText(SnackBar, "Server Error\n"), findsOneWidget);
    });
  });
}
