import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyNumTcd = 'num_tcd';
  static const String defaultNumTcd = '';

  // Отримання збереженого значення (або дефолтного)
  static Future<String> getNumTcd() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNumTcd) ?? defaultNumTcd;
  }

  // Збереження нового значення
  static Future<void> setNumTcd(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNumTcd, value);
  }
}
