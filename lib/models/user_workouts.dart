import 'package:workout_routine/backend/powersync.dart';

class UserWorkoutModel {
  static const String table = "user_workouts";

  final String id;
  final String userId;
  final String workoutId;
  final DateTime playedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserWorkoutModel({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.playedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserWorkoutModel? current;
  static List<UserWorkoutModel> list = [];

  factory UserWorkoutModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'playedAt' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return UserWorkoutModel(
      id: data['id'],
      userId: data['userId'],
      workoutId: data['workoutId'],
      playedAt: data['playedAt'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<UserWorkoutModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'playedAt' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return UserWorkoutModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'workoutId': workoutId,
        'playedAt': playedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<UserWorkoutModel>> getAllByUserId(String userId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE userId = ? ORDER BY createdAt DESC", [userId]);

    return UserWorkoutModel.fromList(results);
  }

  static Future<UserWorkoutModel> getSingle(String id, String userId) async {
    final results = await database.get("SELECT * FROM $table WHERE id = ? AND userId = ?", [id, userId]);

    return UserWorkoutModel.fromJson(results);
  }

  static Stream<List<UserWorkoutModel>> watch(String userId) {
    return database.watch("SELECT * FROM $table WHERE userId = $userId ORDER BY createdAt DESC").map(//
        (results) => results.map((row) => UserWorkoutModel.fromJson(row)).toList() //
        );
  }

  static Future<void> create(String userId, String workoutId, DateTime playedAt) async {
    await database.execute(
      "INSERT INTO $table (userId, workoutId, playedAt, createdAt) VALUES (?, ?, ?, ?)",
      [userId, workoutId, playedAt, DateTime.now()],
    );
  }

  static Future<void> update(String id, String userId, String workoutId, DateTime playedAt) async {
    await database.execute(
      "UPDATE $table SET playedAt = ?, createdAt = ? WHERE id = ? AND userId = ?",
      [playedAt, DateTime.now(), id, userId],
    );
  }

  static Future<void> delete(String id, String userId) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ? AND userId = ?",
      [id, userId],
    );
  }
}
