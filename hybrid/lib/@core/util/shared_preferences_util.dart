import 'package:shared_preferences/shared_preferences.dart';

class _SharedPreferencesKeys {
  static final accountBalanceKey = "accountBalance";
}

class SharedPreferencesUtil {
  static void setAccountBalance(double value) async {
    _setDouble(_SharedPreferencesKeys.accountBalanceKey, value);
  }

  static Future<double> getAccountBalance() async {
    return _getDouble(_SharedPreferencesKeys.accountBalanceKey);
  }

  static void _setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static Future<double> _getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }
}
