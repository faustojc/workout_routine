import 'package:workout_routine/backend/powersync.dart';

class WeekModel {
  static const String table = "weeks";

  final String id;
  final String periodizationId;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeekModel({
    required this.id,
    required this.periodizationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.subtitle,
  });

  static WeekModel? current;
  static List<WeekModel> list = [];

  factory WeekModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return WeekModel(
      id: data['id'],
      periodizationId: data['periodizationId'],
      title: data['title'],
      subtitle: data['subtitle'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WeekModel> fromJsonList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return WeekModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'periodizationId': periodizationId,
        'title': title,
        'subtitle': subtitle,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<WeekModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return results.map((row) => WeekModel.fromJson(row)).toList();
  }

  static Future<List<WeekModel>> getAllByPeriodizationId(String periodizationId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE periodizationId = '$periodizationId'");

    return results.map((row) => WeekModel.fromJson(row)).toList();
  }

  static Future<WeekModel> getSingle(String id) async {
    final result = await database.get("SELECT * FROM $table WHERE id = '$id'");

    return WeekModel.fromJson(result);
  }

  static Future<void> create(String periodizationId, String title, String? subtitle) async {
    await database.execute(
      "INSERT INTO $table (periodizationId, title, subtitle, createdAt) VALUES (?, ?, ?, ?)",
      [periodizationId, title, subtitle, DateTime.now()],
    );
  }

  static Future<void> update(String id, String title, String? subtitle) async {
    await database.execute(
      "UPDATE $table SET title = ?, subtitle = ?, updatedAt = ? WHERE id = ?",
      [title, subtitle, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ?",
      [id],
    );
  }
}
