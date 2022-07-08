import 'package:flutter/cupertino.dart';

class ChatlistProvider extends ChangeNotifier {
  String? _lastMessage = "Loading";
  String? _lateMessageTime = "...";

  String get lastMessage => _lastMessage!;
  String get lastMessageTime => _lateMessageTime!;

  setLastMessageNTime(String message, String time) {
    _lastMessage = message;
    _lateMessageTime = time;
  }
}
