import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

DateFormat get timeFormat => DateFormat.jm();

DateFormat get dateFormat => DateFormat.yMMMMd();

String Function(String) get mandatoryValidator =>
    (val) => val.isEmpty ? "This field is mandatory" : null;

String Function(String) get emailValidator => (email) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)
        ? null
        : "Enter a valid email";

String validatePhone(String phone) {
  print("validating $phone");
  return (phone?.isEmpty ?? true) || phone.length < 6
      ? "Invalid phone number"
      : null;
}

String validatePin(String pin) {
  return (pin?.isEmpty ?? true) || pin.length < 4 || pin.length > 4
      ? "Please enter a 4 digit pin"
      : null;
}

String Function(String) get passwordValidator =>
    (String password) => password.length < 8 ? "Password too short" : null;

Future<T> push<T>(BuildContext context, Widget child) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => child));

void replace(BuildContext context, Widget child) => Navigator.of(context)
    .pushReplacement(MaterialPageRoute(builder: (_) => child));

void pop<T>(BuildContext context,{T data}) => Navigator.of(context).pop<T>(data);

void popToMain(BuildContext context) =>
    Navigator.of(context).popUntil((route) => route.isFirst);

void snack(BuildContext context, String message,
        {bool info = false, Duration duration}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration ?? Duration(seconds: 3),
      backgroundColor: info ? Colors.green : Colors.red,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white,
            ),
      ),
    ));

// Future<UserData> get loadUserData async => UserData(
//       image: await prefsImageUrl.load(),
//       fullName: await prefsFullName.load(),
//       email: await prefsEmail.load(),
//     );
//
// Future<String> readToken(BuildContext context) =>
//     context.read<AuthState>().token;
//
// Future<String> watchToken(BuildContext context) =>
//     context.watch<AuthState>().token;

Future<bool> openMap(
    {double latitude = -3.823216, double longitude = -38.481700}) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
    return true;
  } else {
    return false;
  }
}

Widget getFormFieldError(FormFieldState<String> state) => state.hasError
    ? Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.red.shade700),
            Text(state.errorText,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.red.shade700)),
          ],
        ),
      )
    : SizedBox();
