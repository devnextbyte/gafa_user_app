import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gafamoney/main.dart';
import 'package:gafamoney/view/splash.dart';

void main() {
  testWidgets('Splash Screen', (WidgetTester tester) async {
    await tester.pumpWidget(GafaMoneyApp(home: SplashView()));
    expect(find.byKey(Key("logo")), findsOneWidget);
  });
}
