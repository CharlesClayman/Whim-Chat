import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/screens/views/home_view.dart';
import 'package:whim_chat/src/core/screens/views/signup_profile_view.dart';
import 'package:whim_chat/src/core/screens/views/signup_view.dart';
import 'package:whim_chat/src/core/utils/colors.dart';
import 'package:whim_chat/src/core/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: const SetUpProfile(
          phoneNumber: "",
        ));
  }
}

// StreamBuilder(builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           if (snapshot.hasData) {
//             return HomeScreen();
//           }
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: mainAppColor,
//             ),
//           );
//         }
//         return SignUpScreen();
//       }