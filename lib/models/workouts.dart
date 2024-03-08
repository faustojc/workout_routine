import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class WorkoutModel extends BaseModel {
  static const String _table = "workouts";

  final String id;
  final String daysId;
  final String title;
  final String description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final Duration videoDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutModel({
    required this.id,
    required this.daysId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.videoDuration,
    required this.createdAt,
    required this.updatedAt,
  });

  static WorkoutModel? current;
  static List<WorkoutModel> list = [];

  factory WorkoutModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return WorkoutModel(
      id: data['id'],
      daysId: data['daysId'],
      title: data['title'],
      description: data['description'],
      videoUrl: data['videoUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      videoDuration: data['videoDuration'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WorkoutModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) {
        dynamic newValue = value;

        if ((key == 'createdAt' || key == 'updatedAt') && value is String) {
          newValue = DateTime.parse(value);
        } else if (key == 'videoDuration' && value is int) {
          newValue = Duration(seconds: value);
        }

        return MapEntry(key, newValue);
      });

      return WorkoutModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'daysId': daysId,
        'title': title,
        'description': description,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'videoDuration': videoDuration,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<WorkoutModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $_table");

    return fromList(results);
  }

  static Future<WorkoutModel> getSingle(String id) async {
    final results = await database.get("SELECT * FROM $_table WHERE id = ?", [id]);

    return WorkoutModel.fromJson(results);
  }

  static Future<List<WorkoutModel>> getAllByDaysId(String daysId) async {
    final results = await database.getAll("SELECT * FROM $_table WHERE daysId = ? ORDER BY createdAt DESC", [daysId]);

    return fromList(results);
  }

  static Stream<List<WorkoutModel>> watch(String daysId) {
    return database.watch("SELECT * FROM $_table WHERE daysId = $daysId ORDER BY createdAt DESC").map((results) => fromList(results));
  }

  @override
  String get tableName => _table;
}
