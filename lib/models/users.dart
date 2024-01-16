class UserModel {
  final String id;
  final String email;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserModel? current;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return UserModel(
      id: data['id'],
      email: data['email'],
      password: data['password'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
