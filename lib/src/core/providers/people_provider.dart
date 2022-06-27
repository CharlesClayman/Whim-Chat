import 'package:flutter/cupertino.dart';

class PeopleProvider with ChangeNotifier {
  bool _addingFriend = false;
  String? _photoUrl;
  String? _username;

  bool get addingFriend => _addingFriend;
  String get photoUrl => _photoUrl!;
  String get username => _username!;

  setAddingFriend(bool addingFriend) {
    _addingFriend = addingFriend;
    notifyListeners();
  }

  setChatProfile(String username, String photoUrl) {
    _username = username;
    _photoUrl = photoUrl;
  }
}
