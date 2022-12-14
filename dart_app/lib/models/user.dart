class UserModel {
  final String uid;
  final String email;
  final String username;

  UserModel({required this.uid, required this.email, required this.username});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }
}
