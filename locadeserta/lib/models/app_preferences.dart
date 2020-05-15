import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const CREATOR_PREFIX = 'creator_stories';

class AppPreferences {
  AppPreferences._internal();

  static final AppPreferences instance = AppPreferences._internal();
  SharedPreferences _preferences;
  String _isDarkTheme = 'isDarkTheme';
  String _languageCode = 'languageCode';

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  bool getDarkTheme() {
    return _preferences.getBool(_isDarkTheme) ?? false;
  }

  Future setDarkTheme(bool isDarkTheme) async {
    return await _preferences.setBool(_isDarkTheme, isDarkTheme);
  }

  String getUILanguage() {
    return _preferences.getString(_languageCode);
  }

  Future setUILanguage(String languageCode) async {
    return await _preferences.setString(_languageCode, languageCode);
  }

  Future saveStoryStringByName(String name, String content) async {
    return await _preferences.setString(name, content);
  }

  String readStoryStringByName(String name) {
    return _preferences.get(name);
  }

  String getCreatorStories() {
    var savedStories = _preferences.getString(CREATOR_PREFIX);
    return savedStories ?? '{}';
  }

  Future saveCreatorStory(String name, String content) {
    Map<String, dynamic> stories = jsonDecode(getCreatorStories());
    stories[name] = content;
    return _preferences.setString(CREATOR_PREFIX, jsonEncode(stories));
  }

  Future<bool> deleteCreatorStory(String name) {
    Map<String, dynamic> stories = jsonDecode(getCreatorStories());
    stories.remove(name);
    return _preferences.setString(CREATOR_PREFIX, jsonEncode(stories));
  }

  String readCreatorStoryStringByName(String name) {
    Map<String, dynamic> stories = jsonDecode(getCreatorStories());
    return stories[name];
  }
}
