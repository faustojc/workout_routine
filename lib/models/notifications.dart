import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class NotificationModel {
  static const String table = "notifications";

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
    final data = json.map((key, value) => MapEntry(key, value is String && key == 'createdAt' ? DateTime.parse(value) : value));

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

  static Future<NotificationModel> getSingle(String id) async => await database.get("SELECT * FROM $table WHERE id = ?", [id]).then((result) => NotificationModel.fromJson(result));

  static Future<List<NotificationModel>> getAllByUserId(String userId) async =>
      await database.getAll("SELECT * FROM $table WHERE userId = ?", [userId]).then((results) => NotificationModel.fromList(results));

  static Future<List<NotificationModel>> getAll() async => await database.getAll("SELECT * FROM $table").then((results) => NotificationModel.fromList(results));

  static Stream<List<NotificationModel>> watch(String userId) =>
      database.watch("SELECT * FROM $table WHERE userId = ?", parameters: [userId]).map((data) => data.map((row) => NotificationModel.fromJson(row)).toList());

  static Future<ResultSet?> create(Map<String, dynamic> fields) async {
    if (fields.isEmpty) return null;

    List<String> columns = [];
    List<String> values = [];
    List<String> placeholders = [];

    fields.forEach((key, value) {
      value = ((key == 'createdAt' || key == 'updatedAt') && value is DateTime) ? value.toIso8601String() : value;

      columns.add(key);
      values.add(value);
      placeholders.add("?");
    });

    String sql = "INSERT INTO $table (${columns.join(', ')}) VALUES (${placeholders.join(', ')})";
    return await database.execute(sql, values);
  }

  static Future<ResultSet?> update(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return null;

    List<String> updates = [];
    List<dynamic> values = [];

    fields.forEach((key, value) {
      updates.add("$key = ?");
      values.add(value);
    });

    String sql = "UPDATE $table SET ${updates.join(', ')} WHERE id = ?";
    values.add(id);

    return await database.execute(sql, values);
  }

  static Future<ResultSet> delete(String id) async {
    return await database.execute("DELETE FROM $table WHERE id = ?", [id]);
  }
}
