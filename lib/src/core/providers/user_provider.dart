import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  String? _username;
  String? _phone;
  String? _photoUrl;
  String? _status;

  String get userId => _auth.currentUser!.uid;
  String get username => _username!;
  String get phone => _phone!;
  String get phoneUrl => _photoUrl!;
  String get status => _status!;

  void setUserStatus(String status) async {
    await DatabaseService()
        .updateUserStatus(userId, status)
        .then((value) => _status = status);
  }
}
