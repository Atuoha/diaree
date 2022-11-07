import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';

class SettingsData extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool _isPinSet = false;
  bool _isSyncAutomatically = false;
  ThemeData? _themeData;
  SettingsData(this._themeData);

  get getThemeData => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  get getIsDarkTheme => _isDarkTheme;

  get getIsPinSet => _isPinSet;

  get getIsSyncAutomatically => _isSyncAutomatically;

  void toggleIsDarkTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void toggleIsPinSet() {
    _isPinSet = !_isPinSet;
    notifyListeners();
  }

  void toggleIsSyncAutomatically() {
    _isSyncAutomatically = !_isSyncAutomatically;
    notifyListeners();
  }
}
