import 'package:flutter/material.dart';
import '../assets/colors/my_palette.dart';
import 'storage_manager.dart';
import 'package:system_theme/system_theme.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: MyPalette.firstPalette,
    primaryColor: const Color(0xFF212121),
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
    
  );

  final lightTheme = ThemeData(
    primarySwatch: MyPalette.firstPalette,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
    
  );

  ThemeData? _themeData;
  bool? _isDarkMode;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      //print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    _isDarkMode = true;
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    _isDarkMode = false;

    notifyListeners();
  }

  ThemeData getTheme() {
    if (_themeData == null) {
      if (SystemTheme.isDarkMode) {
        _themeData = darkTheme;
        StorageManager.saveData('themeMode', 'dark');
        _isDarkMode = true;
      } else {
        _themeData = lightTheme;
        StorageManager.saveData('themeMode', 'light');
        _isDarkMode = false;
      }
    }

    return _themeData!;
  }

  bool isDarkMode() {
    return _isDarkMode ?? false;
  }
}
