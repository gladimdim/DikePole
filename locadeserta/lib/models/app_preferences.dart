import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._internal();

  static final AppPreferences instance = AppPreferences._internal();
  SharedPreferences _preferences;
  String _isDarkTheme = 'isDarkTheme';

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    return;
  }

  bool getDarkTheme() {
    return _preferences.getBool(_isDarkTheme);
  }

  Future setDarkTheme(bool isDarkTheme) async {
    return await _preferences.setBool(_isDarkTheme, isDarkTheme);
  }
}