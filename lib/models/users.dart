import 'package:workout_routine/backend/powersync.dart';

class UserModel {
  static const String table = "users";

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
  static List<UserModel> list = [];

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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

  static Future<List<UserModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return results.map((row) => UserModel.fromJson(row)).toList();
  }

  static Future<UserModel> getSingle(String id) async {
    final results = await database.get("SELECT * FROM $table WHERE id = ?", [id]);

    return UserModel.fromJson(results);
  }

  static Future<UserModel> getByEmail(String email) async {
    final results = await database.get("SELECT * FROM $table WHERE email = ?", [email]);

    return UserModel.fromJson(results);
  }

  static Future<void> create(String email, String password) async {
    await database.execute(
      "INSERT INTO $table (email, password, createdAt) VALUES (?, ?, ?)",
      [email, password, DateTime.now()],
    );
  }

  static Future<void> update(String id, String email, String password) async {
    await database.execute(
      "UPDATE $table SET email = ?, password = ?, updatedAt = ? WHERE id = ?",
      [email, password, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ?",
      [id],
    );
  }
}
