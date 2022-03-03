import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gafamoney/view/auth/login_view.dart';
import 'package:gafamoney/view/home.dart';
import 'package:gafamoney/view/splash.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/external_enum.dart';
import 'package:provider/provider.dart';

import 'utils/country_data.dart';

void main() {
  for (int i = 0; i < codes.length; i++) {
    if (codes[i]['dial_code'] == "+92") {
      print("country code: $i");
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: GafaMoneyApp(),
    ),
  );
}

class GafaMoneyApp extends StatelessWidget {
  final Widget home;

  const GafaMoneyApp({Key key, this.home}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      // supportedLocales: [const Locale('en', ''), const Locale('fr', '')],
      title: 'GafaMoney',
      theme: ThemeData(
        // fontFamily: "montserrat",
        primarySwatch: MaterialColor(
          0xFF508345,
          <int, Color>{
            50: Color(0xFFa8c1a2),
            100: Color(0xFF96b58f),
            200: Color(0xFF85a87d),
            300: Color(0xFF739c6a),
            400: Color(0xFF628f58),
            500: Color(0xFF508345),
            600: Color(0xFF48763e),
            700: Color(0xFF406937),
            800: Color(0xFF385c30),
            900: Color(0xFF304f29),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF508345),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Color(0xFF1B1B1B)),
          subtitle1: TextStyle(color: Color(0xFF1B1B1B)),
        ),
        buttonTheme: ButtonThemeData(
            minWidth: 0,
            height: 44,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
      ),
      home: home ??
          Consumer<AuthState>(
            builder: (context, state, child) {
              switch (state.status) {
                case ExternalAuthStatus.INITIALISING:
                  state.initialise();
                  return SplashView();
                case ExternalAuthStatus.LOGGED_IN:
                  return Home();
                case ExternalAuthStatus.LOGGED_OUT:
                  return LoginView();
                default:
                  return Center(child: Text("Unknown state"));
              }
            },
          ),
    );
  }
}
