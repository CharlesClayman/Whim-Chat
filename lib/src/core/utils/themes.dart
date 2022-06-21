import 'package:flutter/material.dart';
import 'package:whim_chat/main.dart';
import 'package:whim_chat/src/core/utils/colors.dart';

ThemeData? activeTheme;

final ThemeData darkMode = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    progressIndicatorTheme:
        ThemeData().progressIndicatorTheme.copyWith(color: mainAppColor),
    primaryColor: mainAppColor,
    scaffoldBackgroundColor: darkModeColor,
    colorScheme: ThemeData().colorScheme.copyWith(secondary: darkModeColor),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: mainAppColor),
    dividerTheme: ThemeData().dividerTheme.copyWith(color: mainAppColor),
    tabBarTheme: ThemeData().tabBarTheme.copyWith(
        labelColor: mainAppColor,
        indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: mainAppColor, width: 3))),
    iconTheme: ThemeData().iconTheme,
    appBarTheme: ThemeData().appBarTheme.copyWith(color: mainAppColor),
    radioTheme: ThemeData()
        .radioTheme
        .copyWith(fillColor: MaterialStateProperty.all(mainAppColor)));

final ThemeData lightMode = ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    progressIndicatorTheme:
        ThemeData().progressIndicatorTheme.copyWith(color: mainAppColor),
    primaryColor: mainAppColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: mainAppColor,
      unselectedItemColor: Colors.black,
    ),
    dividerTheme: ThemeData().dividerTheme.copyWith(color: mainAppColor),
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(primary: mainAppColor, secondary: lightModeColor),
    scaffoldBackgroundColor: lightModeColor,
    appBarTheme: ThemeData().appBarTheme.copyWith(color: mainAppColor),
    tabBarTheme: ThemeData().tabBarTheme.copyWith(
        labelColor: mainAppColor,
        indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: mainAppColor, width: 3))),
    radioTheme: ThemeData()
        .radioTheme
        .copyWith(fillColor: MaterialStateProperty.all(mainAppColor)));
