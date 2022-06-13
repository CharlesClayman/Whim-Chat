class User {
  final String username;
  final String phone;
  final String photoUrl;
  const User(
      {required this.username, required this.phone, required this.photoUrl});

  Map<String, dynamic> toJson() =>
      {'username': username, 'phone': phone, 'photoUrl': photoUrl};
}
