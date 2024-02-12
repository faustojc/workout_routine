import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class PersonalRecordModel {
  static const String table = "personal_records";

  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonalRecordModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  static PersonalRecordModel? current;
  static List<PersonalRecordModel> list = [];

  factory PersonalRecordModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return PersonalRecordModel(
      id: data['id'],
      userId: data['userId'],
      title: data['title'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<PersonalRecordModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return PersonalRecordModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<PersonalRecordModel>> getAllByUserId(String userId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE userId = ? ORDER BY createdAt DESC", [userId]);

    return PersonalRecordModel.fromList(results);
  }

  static Stream<List<PersonalRecordModel>> watch(String userId) {
    return database.watch("SELECT * FROM $table WHERE userId = $userId ORDER BY createdBy DESC").map(//
        (results) => results.map((row) => PersonalRecordModel.fromJson(row)).toList() //
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
