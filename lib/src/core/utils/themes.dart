import 'package:flutter/material.dart';
import 'package:whim_chat/main.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

final ThemeData darkMode = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: mainAppColor,
  scaffoldBackgroundColor: darkModeColor,
  colorScheme: ThemeData().colorScheme.copyWith(secondary: darkModeColor),
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(selectedItemColor: mainAppColor),
);

final ThemeData lightMode = ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: mainAppColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: mainAppColor,
      unselectedItemColor: Colors.black,
    ),
    colorScheme: ThemeData().colorScheme.copyWith(secondary: lightModeColor),
    scaffoldBackgroundColor: lightModeColor,
    tabBarTheme: ThemeData().tabBarTheme.copyWith(
        labelColor: mainAppColor,
        indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: mainAppColor, width: 3))));
