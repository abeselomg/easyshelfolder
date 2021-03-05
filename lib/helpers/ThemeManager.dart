import 'dart:convert';

import 'package:easy_shelf/helpers/sharedPref.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );
  // theme: ThemeData(
  //     scaffoldBackgroundColor: Colors.white,
  //     primaryColor: Color.fromRGBO(44, 149, 121, 1.0)
  // ),
  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Color.fromRGBO(44, 149, 121, 1.0),
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );
  SharedPref sharedPref = SharedPref();
  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    sharedPref.readStr('themeMode').then((value) {
      print('value read from storage: ' + value);
      if (value == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    sharedPref.saveString('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    sharedPref.saveString('themeMode', 'light');
    notifyListeners();
  }
}
