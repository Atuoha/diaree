import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';

class SettingsData extends ChangeNotifier {
  ThemeData? _themeData;
  SettingsData(this._themeData);

  get getThemeData => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
