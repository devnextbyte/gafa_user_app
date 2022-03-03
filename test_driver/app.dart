import 'package:kio/connection/hussain.dart';

import '../lib/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();
  Hussain.initialize(baseUrl: "https://api.gafapay.nextbytesolutions.com/");
  runApp(GafaMoneyApp());
}