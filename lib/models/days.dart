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
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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

  static Future<void> create(String weeksId, String title, String? subtitle) async {
    await database.execute(
      "INSERT INTO $table (weeksId, title, subtitle, createdAt) VALUES (?, ?, ?, ?)",
      [weeksId, title, subtitle, DateTime.now()],
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
