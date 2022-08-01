import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final SharedPreferences preferences;

  UserPreferences(this.preferences);

  Future<bool> setCurrency(String currency) async {
    return preferences.setString(_Keys.currencyKey, currency);
  }

  String getCurrency() {
    final value = preferences.getString(_Keys.currencyKey);
    return value ?? "";
  }
}

class _Keys {
  static const currencyKey = "CUR";
}
