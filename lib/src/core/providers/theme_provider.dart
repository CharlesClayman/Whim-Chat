import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whim_chat/src/core/utils/themes.dart';

class ThemeProvider with ChangeNotifier {
  final List<String> _themes = ["Light", "Dark"];

  String? _selectedTheme;
  ThemeData? _themeData;

  ThemeProvider(this._themeData, this._selectedTheme);

  ThemeData get getTheme => _themeData!;
  String get getSelectedTheme => _selectedTheme!;
  List<String> get getListOfThemes => _themes;

  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  setSelectedTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }
}
