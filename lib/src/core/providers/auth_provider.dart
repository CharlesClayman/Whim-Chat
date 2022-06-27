import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../screens/views/home_view.dart';
import '../screens/views/signup_view.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  authChecker() {
    final currentUser = auth.currentUser;
    if (currentUser?.uid != null) {
      return HomeScreen();
    }
    return SignUpScreen();
  }
}
