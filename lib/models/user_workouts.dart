import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class UserWorkoutModel extends BaseModel {
  static const String _table = "user_workouts";

  final String id;
  final String userId;
  final String workoutId;
  final String status;
  final Duration playedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserWorkoutModel({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.status,
    required this.playedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserWorkoutModel? current;
  static List<UserWorkoutModel> list = [];

  factory UserWorkoutModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'playedAt' || key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return UserWorkoutModel(
      id: data['id'],
      userId: data['userId'],
      workoutId: data['workoutId'],
      status: data['status'],
      playedAt: data['playedAt'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<UserWorkoutModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) {
        dynamic newValue = value;

        if ((key == 'playedAt' || key == 'createdAt' || key == 'updatedAt') && value is String) {
          newValue = DateTime.parse(value);
        } else if (key == 'videoDuration' && value is int) {
          newValue = Duration(seconds: value);
        }

        return MapEntry(key, newValue);
      });

      return UserWorkoutModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'workoutId': workoutId,
        'status': status,
        'playedAt': playedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<UserWorkoutModel>> getAllByUserId(String userId) async {
    final results = await database.getAll("SELECT * FROM $_table WHERE userId = ? ORDER BY createdAt DESC", [userId]);

    return UserWorkoutModel.fromList(results);
  }

  static Future<UserWorkoutModel> getSingle(String id, String userId) async {
    final results = await database.get("SELECT * FROM $_table WHERE id = ? AND userId = ?", [id, userId]);

    return UserWorkoutModel.fromJson(results);
  }

  static Stream<List<UserWorkoutModel>> watch(String userId) {
    return database.watch("SELECT * FROM $_table WHERE userId = $userId ORDER BY createdAt DESC").map(//
        (results) => results.map((row) => UserWorkoutModel.fromJson(row)).toList() //
        );
  }

  @override
  String get tableName => _table;
}
