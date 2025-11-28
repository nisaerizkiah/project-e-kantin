// lib/models/user_model_kifiyah.dart
class UserModelKifiyah {
  final String userId;
  final String email;
  final String fullName;
  final String password;

  UserModelKifiyah({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.password,
  });

  factory UserModelKifiyah.fromJson(Map<String, dynamic> json) {
    return UserModelKifiyah(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      password: json['password'] ?? '',
    );
  }

  get name => null;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'password': password,
    };
  }
}