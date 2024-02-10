import 'package:workout_routine/backend/powersync.dart';

class WorkoutModel {
  static const String table = 'workouts';

  final String id;
  final String daysId;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String? createdAt;
  final String? updatedAt;

  WorkoutModel({
    required this.id,
    required this.daysId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
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
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }

  static List<WorkoutModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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
    return database.watch("SELECT * FROM $table WHERE daysId = $daysId ORDER BY createdAt DESC").map(//
        (results) => fromList(results) //
        );
  }

  static Future<void> create(String daysId, String title, String description, String videoUrl, String thumbnailUrl) async {
    await database.execute(
      "INSERT INTO $table (daysId, title, description, video_url, thumbnail_url, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [daysId, title, description, videoUrl, thumbnailUrl, DateTime.now(), DateTime.now()],
    );
  }

  static Future<void> update(String id, String daysId, String title, String description, String videoUrl, String thumbnailUrl) async {
    await database.execute(
      "UPDATE $table SET daysId = ?, title = ?, description = ?, video_url = ?, thumbnail_url = ?, updated_at = ? WHERE id = ?",
      [daysId, title, description, videoUrl, thumbnailUrl, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ?",
      [id],
    );
  }
}
