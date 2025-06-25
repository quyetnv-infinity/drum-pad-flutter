import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeIdKey = 'theme_id';
  String _themeId = 'default';

  ThemeModel _currentTheme = listThemes.firstWhere((element) => element.id == 'default',);
  ThemeModel get currentTheme => _currentTheme;

  ThemeProvider(){
    _loadThemeId();
  }

  String get themeId => _themeId;

  set themeId(String value) {
    if (_themeId != value) {
      _themeId = value;
      _currentTheme = listThemes.firstWhere((element) => element.id == value,);
      _saveThemeId(value);
      notifyListeners();
    }
  }

  Future<void> _loadThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeId = prefs.getString(_themeIdKey);
    if (savedThemeId != null && savedThemeId != _themeId) {
      _themeId = savedThemeId;
      _currentTheme = listThemes.firstWhere((element) => element.id == savedThemeId,);
      notifyListeners();
    }
  }

  Future<void> _saveThemeId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeIdKey, value);
  }
}