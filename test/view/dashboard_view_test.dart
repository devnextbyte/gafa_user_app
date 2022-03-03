import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/model/company_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/view/dashboard/dashboard.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../dummy/companies_dummy_data.dart';
import '../dummy/server_err_resp.dart';
import '../reusable/mock_auth.dart';
class MockCompaniesLine extends Mock implements CompanyListLine {}

void main() {
  final mockAuthState = MockAuthState();

  group("Test Dashboard", () {
    final mcl = MockCompaniesLine();
    when(mcl.getCompaniesList("dummy")).thenAnswer((realInvocation) async =>
        HussainResp.fromSuccess(
            statusCode: 200,
            response: CompanyListResp.fromJson(
                CompaniesDummyData.instance.getCompaniesListResp)));
    testWidgets("Check labels with all success", (tester) async {
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
            value: mockAuthState,
            builder: (context, state) => Dashboard(line: mcl),
          ),
        ),
      );
      expect(find.text("My Balance"), findsOneWidget);
      expect(find.text("CFA *****"), findsOneWidget);
      expect(find.text("Add Money"), findsOneWidget);
      expect(find.text("Scan to Pay"), findsOneWidget);
      expect(find.text("Send Money"), findsOneWidget);
      expect(find.text("Request Money"), findsOneWidget);
      expect(find.text("Merchant"), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(Key("companies")), findsOneWidget);
      expect(find.text("Bill / Recharge"), findsOneWidget);
      expect(find.text("Airtime Purchase"), findsOneWidget);
      expect(find.byKey(Key("Bill Payment2")), findsOneWidget);
      expect(find.byKey(Key("Air Time Top Up Company1")), findsOneWidget);

      expect(
          find.ancestor(
              of: find.byKey(Key("Bill Payment2")),
              matching: find.byKey(Key("Bill / Recharge"))),
          findsOneWidget);

      expect(
          find.ancestor(
              of: find.byKey(Key("Air Time Top Up Company1")),
              matching: find.byKey(Key("Airtime Purchase"))),
          findsOneWidget);
    });

    testWidgets("Handle load balance error", (tester) async {
      when(mockAuthState.loadBalance())
          .thenAnswer((a) async => "Error from server");
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
            value: mockAuthState,
            builder: (context, state) => Dashboard(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("Error from server"), findsOneWidget);
    });

    testWidgets("Success balance", (tester) async {
      when(mockAuthState.loadBalance()).thenAnswer((a) async => null);
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
            value: mockAuthState,
            builder: (context, state) => Dashboard(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("Error from server"), findsNothing);
    });

    testWidgets("Check balance hide show", (tester) async {
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
            value: mockAuthState,
            builder: (context, state) => Dashboard(),
          ),
        ),
      );

      expect(find.text("CFA *****"), findsOneWidget);
      expect(find.text("CFA 500.25"), findsNothing);
      expect(find.byIcon(FontAwesomeIcons.eyeSlash), findsNothing);
      expect(find.byIcon(FontAwesomeIcons.eye), findsOneWidget);

      await tester.tap(find.byIcon(FontAwesomeIcons.eye));
      await tester.pumpAndSettle();

      expect(find.text("CFA *****"), findsNothing);
      expect(find.text("CFA 500.25"), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.eyeSlash), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.eye), findsNothing);
    });
  });

  group("Companies with error", () {
    final mcl = MockCompaniesLine();
    when(mcl.getCompaniesList("dummy")).thenAnswer(
        (realInvocation) async => getServerErrResp<CompanyListResp>());

    testWidgets("Loading companies with error", (tester) async {
      await tester.pumpWidget(
        GafaMoneyApp(
          home: ChangeNotifierProvider<AuthState>.value(
            value: mockAuthState,
            builder: (context, state) => Dashboard(line: mcl),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("Error from server\n"), findsOneWidget);
      expect(find.byKey(Key("companies")), findsNothing);
    });
  });
}
