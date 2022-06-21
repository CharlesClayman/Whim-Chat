import 'package:flutter/cupertino.dart';

class PeopleProvider with ChangeNotifier {
  bool _addingFriend = false;

  bool get addingFriend => _addingFriend;

  setAddingFriend(bool addingFriend) {
    _addingFriend = addingFriend;
    notifyListeners();
  }
}
