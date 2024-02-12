import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class DayModel {
  static const String table = "days";

  final String id;
  final String weeksId;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  DayModel({
    required this.id,
    required this.weeksId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.subtitle,
  });

  static DayModel? current;
  static List<DayModel> list = [];

  factory DayModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return DayModel(
      id: data['id'],
      weeksId: data['weeksId'],
      title: data['title'],
      subtitle: data['subtitle'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<DayModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return DayModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'weeksId': weeksId,
        'title': title,
        'subtitle': subtitle,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<DayModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return results.map((row) => DayModel.fromJson(row)).toList();
  }

  static Future<List<DayModel>> getAllByWeekId(String weekId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE weeksId = '$weekId'");

    return results.map((row) => DayModel.fromJson(row)).toList();
  }

  static Future<DayModel> getSingle(String id) async {
    final result = await database.get("SELECT * FROM $table WHERE id = $id");

    return DayModel.fromJson(result);
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
