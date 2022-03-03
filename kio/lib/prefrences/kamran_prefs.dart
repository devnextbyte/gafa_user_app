
import 'Kamran.dart';

final kamranPrefs = KamranPrefs();

class KamranPrefs{
  final expiresAtInMillis = Kamran<int>("expiresAtInMillis");
  final token = Kamran<String>("token");
  final refreshToken = Kamran<String>("refreshToken");
}