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
  static List<UserModel>? list;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return UserModel(
      id: data['id'],
      email: data['email'],
      password: data['password'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<UserModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return UserModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
