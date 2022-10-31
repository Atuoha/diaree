import "package:flutter/foundation.dart";

class SettingsData extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool _isPinSet = false;
  bool _isSyncAutomatically = false;

  get isDarkTheme {
    return _isDarkTheme;
  }

  get isPinSet {
    return _isPinSet;
  }

  get isSyncAutomatically {
    return _isSyncAutomatically;
  }

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
