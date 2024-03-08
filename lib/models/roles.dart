import 'package:workout_routine/backend/powersync.dart';

import 'base_model.dart';

class RoleModel extends BaseModel {
  static const String _table = "roles";

  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  static RoleModel? current;

  factory RoleModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return RoleModel(
      id: data['id'],
      userId: data['userId'],
      name: data['name'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<RoleModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

      return RoleModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static Future<RoleModel> getUserRole(String userId) async {
    final result = await database.get("SELECT * FROM $_table WHERE userId = ?", [userId]);

    return RoleModel.fromJson(result);
  }

  @override
  String get tableName => _table;
}
