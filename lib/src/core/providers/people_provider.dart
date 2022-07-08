import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PeopleProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  bool _addingFriend = false;
  String? _photoUrl;
  String? _username;
  String? _friendId;
  String _status = "Offline";

  bool get addingFriend => _addingFriend;
  String? get friendPhotoUrl => _photoUrl;
  String get friendUsername => _username!;
  String get friendId => _friendId!;
  String get status => _status;

  setAddingFriend(bool addingFriend) {
    _addingFriend = addingFriend;
    notifyListeners();
  }

  setChatProfile(dynamic data) {
    _friendId = data.get('id');
    _username = data.get('username');
    _photoUrl = data.get('photoUrl');
    _status = data.get('status');
  }
}
