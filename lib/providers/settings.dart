import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';

class SettingsData extends ChangeNotifier {
  ThemeData? _themeData;

  SettingsData(this._themeData);

  get getThemeData => _themeData;
  get getThemeBackgroundColor => _themeData!.backgroundColor;
  get getThemeColor => _themeData!.primaryColorLight;
  get getThemeColor2 => _themeData!.primaryColorDark;

  get getTextFieldColor => _themeData!.inputDecorationTheme.fillColor;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
