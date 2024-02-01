import 'package:workout_routine/backend/powersync.dart';

class NotificationModel {
  static const String tableName = "notifications";

  final String id;
  final String userId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  static List<NotificationModel> list = [];

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' ? DateTime.parse(value) : value));

    return NotificationModel(id: data['id'], userId: data['userId'], message: data['message'], isRead: data['isRead'], createdAt: data['createdAt']);
  }

  static List<NotificationModel> fromList(List<Map<dynamic, dynamic>> source) {
    return source.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' ? DateTime.parse(value) : value));

      return NotificationModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'isRead': isRead,
        'createdAt': createdAt,
      };

  static Future<NotificationModel> getSingle(String id) async =>
      await database.get("SELECT * FROM $tableName WHERE id = ?", [id]).then((result) => NotificationModel.fromJson(result));

  static Future<List<NotificationModel>> getAllByUserId(String userId) async =>
      await database.getAll("SELECT * FROM $tableName WHERE userId = ?", [userId]).then((results) => NotificationModel.fromList(results));

  static Future<List<NotificationModel>> getAll() async => await database.getAll("SELECT * FROM $tableName").then((results) => NotificationModel.fromList(results));

  static Stream<List<NotificationModel>> watch(String userId) =>
      database.watch("SELECT * FROM $tableName WHERE userId = ?", parameters: [userId]).map((data) => data.map((row) => NotificationModel.fromJson(row)).toList());

  static Future<void> create(String userId, String message) async => await database.execute("INSERT INTO $tableName (userId, message) VALUES (?, ?)", [userId, message]);

  static Future<void> update(String id, String userId, bool isRead, String message) async =>
      await database.execute("UPDATE $tableName SET userId = ?, message = ?, isRead = ? WHERE id = ?", [userId, message, isRead, id]);

  static Future<void> delete(String id) async => await database.execute("DELETE FROM $tableName WHERE id = ?", [id]);
}
