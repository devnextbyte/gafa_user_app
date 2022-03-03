import 'package:shared_preferences/shared_preferences.dart';

class Kamran<T> {
  final String key;

  Kamran(String key) : this.key = "Kamran$key" {
    if (![int, double, String, bool].any((t) => t == T)) {
      throw ArgumentError(
          "Only native type allowed, given type ${T.toString()}");
    }
  }

  Future<bool> save(T value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case int:
        return prefs.setInt(key, value as int);
      case double:
        return prefs.setDouble(key, value as double);
      case String:
        return prefs.setString(key, value as String);
      case bool:
        return prefs.setBool(key, value as bool);
      default:
        throw ArgumentError("Non native type not possible here.");
    }
  }

  Future<T> load() async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case int:
        return prefs.getInt(key) as T;
      case double:
        return prefs.getDouble(key) as T;
      case String:
        return prefs.getString(key) as T;
      case bool:
        return prefs.getBool(key) as T;
      default:
        throw ArgumentError("Non native type not possible here.");
    }
  }
}
