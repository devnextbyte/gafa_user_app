import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/model/gafa_user_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/view/reusable/recent_contacts_view.dart';
import 'package:kio/connection/resp/hussin_resp.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy/recent_contacts_dummy.dart';
import '../../dummy/server_err_resp.dart';
import '../../reusable/mock_auth.dart';

class MockRecentContactsLine extends Mock implements RecentContactsLine {}

Future<void> pumpWidget(MockRecentContactsLine mrcl, WidgetTester tester) {
  return tester.pumpWidget(
    GafaMoneyApp(
      home: ChangeNotifierProvider<AuthState>.value(
          value: MockAuthState(),
          builder: (context, widget) =>
              Scaffold(body: RecentContactsView(line: mrcl))),
    ),
  );
}

void setSuccWhen(MockRecentContactsLine line, dynamic json) {
  when(line.getRecentContacts("dummy")).thenAnswer((realInvocation) async =>
      HussainResp.fromSuccess(
          statusCode: 0, response: RecentContactsResp.fromJson(json)));
}

void main() {
  group("Test List of contacts view", () {
    testWidgets("Loading at start", (tester) async {
      final mrcl = MockRecentContactsLine();
      setSuccWhen(mrcl, emptyList);
      await pumpWidget(mrcl, tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Contacts showing", (tester) async {
      final mrcl = MockRecentContactsLine();

      setSuccWhen(mrcl, getRecentContactsDummy);
      await pumpWidget(mrcl, tester);
      await tester.pumpAndSettle();
      expect(find.text("Kamran"), findsOneWidget);
      expect(find.text("Bashir"), findsOneWidget);
    });

    testWidgets("Empty contacts", (tester) async {
      final mrcl = MockRecentContactsLine();
      setSuccWhen(mrcl, emptyList);
      await pumpWidget(mrcl, tester);
      await tester.pump();
      expect(find.text("No recent contacts found"), findsOneWidget);
    });

    testWidgets("Handle error", (tester) async {
      final mrcl = MockRecentContactsLine();
      when(mrcl.getRecentContacts("dummy")).thenAnswer((realInvocation) async =>
          HussainResp.fromErrMsg("Error from server"));
      await pumpWidget(mrcl, tester);
      await tester.pump();
      expect(find.text("Error from server\n"), findsOneWidget);
    });
  });
}
