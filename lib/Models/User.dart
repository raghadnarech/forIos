class User {
  bool? role;
  String? token;
  User({this.role, this.token});
  factory User.fromJson(Map<String, dynamic> responsedata) {
    return User(
      role: responsedata['role'] == "admin" ? true : false,
      token: responsedata['token'],
    );
  }
}
