import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class PRHistoryModel {
  static const String table = "personal_records_history";

  final String id;
  final String prId;
  final String userId;
  final num weight;
  final DateTime createdAt;

  PRHistoryModel({
    required this.id,
    required this.prId,
    required this.userId,
    required this.weight,
    required this.createdAt,
  });

  static PRHistoryModel? current;
  static List<PRHistoryModel> list = [];

  factory PRHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt') ? DateTime.parse(value) : value));

    return PRHistoryModel(
      id: data['id'],
      prId: data['prId'],
      userId: data['userId'],
      weight: data['weight'],
      createdAt: data['createdAt'],
    );
  }

  static List<PRHistoryModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' ? DateTime.parse(value) : value));

      return PRHistoryModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prId': prId,
        'userId': userId,
        'weight': weight,
        'createdAt': createdAt,
      };

  static Future<List<PRHistoryModel>> getAllByUserId(String userId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE userId = ? ORDER BY createdAt DESC", [userId]);

    return PRHistoryModel.fromList(results);
  }

  static Future<PRHistoryModel> getSingle(String id, String prId, String userId) async {
    final results = await database.get("SELECT * FROM $table WHERE id = ? AND prId = ? AND userId = ?", [id, prId, userId]);

    return PRHistoryModel.fromJson(results);
  }

  static Stream<List<PRHistoryModel>> watch(String userId) {
    return database.watch("SELECT * FROM $table WHERE userId = $userId ORDER BY createdAt DESC").map(//
        (results) => results.map((row) => PRHistoryModel.fromJson(row)).toList() //
        );
  }

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
