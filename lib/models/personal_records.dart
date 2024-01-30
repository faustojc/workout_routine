import 'package:workout_routine/backend/powersync.dart';

class PersonalRecordModel {
  static const String table = 'personal_records';

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
    final data = json.map((key, value) => MapEntry(key, (value is String) && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

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

  static Future<void> create(String userId, String title) async {
    await database.execute(
      "INSERT INTO $table (userId, title, createdAt, updatedAt) VALUES (?, ?, ?, ?)",
      [userId, title, DateTime.now(), DateTime.now()],
    );
  }

  static Future<void> update(String id, String userId, String title) async {
    await database.execute(
      "UPDATE $table SET title = ?, updatedAt = ? WHERE id = ? AND userId = ?",
      [title, DateTime.now(), id, userId],
    );
  }

  static Future<void> delete(String id, String userId) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ? AND userId = ?",
      [id, userId],
    );
  }
}
