class ChatMessage {
  String? from;
  String? to;
  String? body;
  DateTime? timeStamp;

  ChatMessage({this.from, this.to, this.body, this.timeStamp});

  Map<String, dynamic> toJson() {
    return {'from': from, 'to': to, 'body': body, 'timeStamp': timeStamp};
  }
}
