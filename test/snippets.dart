import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:kio/connection/param/hussain_connect_param.dart';

Future<void> testFlagChange(WidgetTester tester) async {
  expect(find.text("Phone Number"), findsOneWidget);
  final afg = find.text("+93");
  expect(afg, findsNothing);
  await tester.tap(find.byKey(Key("flag_widget")));
  await tester.pumpAndSettle();
  await tester.tap(afg);
  await tester.pumpAndSettle();
  expect(afg, findsOneWidget);
}

Future<String> getToken() async {
  final authState = AuthState();
  await authState.login(HussainConnectParam(
      userName: "+221123456786", password: "1111", role: "Customer"));
  return authState.token;
}