import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whim_chat/src/core/providers/auth_provider.dart';
import 'package:whim_chat/src/core/providers/people_provider.dart';
import 'package:whim_chat/src/core/providers/theme_provider.dart';
import 'package:whim_chat/src/core/screens/views/home_view.dart';
import 'package:whim_chat/src/core/screens/views/signup_view.dart';
import 'package:whim_chat/src/core/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final pref = await SharedPreferences.getInstance();
  final themeColor = pref.getString('ThemeMode');

  if (themeColor == "Dark") {
    activeTheme = darkMode;
  } else if (themeColor == "Light") {
    activeTheme = lightMode;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(activeTheme ?? lightMode, themeColor ?? "Light")),
      ChangeNotifierProvider(create: (context) => PeopleProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.getTheme,
        home: authProvider.authChecker());
  }
}
