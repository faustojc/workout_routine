import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class WorkoutModel {
  static const String table = "workouts";

  final String id;
  final String daysId;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final Duration videoDuration;
  final String? createdAt;
  final String? updatedAt;

  WorkoutModel({
    required this.id,
    required this.daysId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.videoDuration,
    this.createdAt,
    this.updatedAt,
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
      videoUrl: data['video_url'],
      thumbnailUrl: data['thumbnail_url'],
      videoDuration: data['videoDuration'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
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
        'video_url': videoUrl,
        'thumbnail_url': thumbnailUrl,
        'videoDuration': videoDuration,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  static Future<List<WorkoutModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return fromList(results);
  }

  static Future<WorkoutModel> getSingle(String id) async {
    final results = await database.get("SELECT * FROM $table WHERE id = ?", [id]);

    return WorkoutModel.fromJson(results);
  }

  static Future<List<WorkoutModel>> getAllByDaysId(String daysId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE daysId = ? ORDER BY createdAt DESC", [daysId]);

    return fromList(results);
  }

  static Stream<List<WorkoutModel>> watch(String daysId) {
    return database.watch("SELECT * FROM $table WHERE daysId = $daysId ORDER BY createdAt DESC").map((results) => fromList(results));
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
