class User {
  final String id;
  final String username;
  final String phone;
  final String? photoUrl;
  final String status;
  const User(
      {required this.id,
      required this.username,
      required this.phone,
      required this.photoUrl,
      this.status = "offline"});

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'phone': phone,
        'photoUrl': photoUrl,
        'status': status,
      };
}
