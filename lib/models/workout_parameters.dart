import 'package:workout_routine/backend/powersync.dart';

class WorkoutParameterModel {
  static const String table = 'workout_parameters';

  final String id;
  final String workoutId;
  final String name;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutParameterModel({
    required this.id,
    required this.workoutId,
    required this.name,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  static WorkoutParameterModel? current;
  static List<WorkoutParameterModel> list = [];

  factory WorkoutParameterModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return WorkoutParameterModel(
      id: data['id'],
      workoutId: data['workoutId'],
      name: data['name'],
      value: data['value'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WorkoutParameterModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return WorkoutParameterModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutId': workoutId,
        'name': name,
        'value': value,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<WorkoutParameterModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return results.map((row) => WorkoutParameterModel.fromJson(row)).toList();
  }

  static Future<WorkoutParameterModel> getSingle(String id) async {
    final results = await database.get("SELECT * FROM $table WHERE id = ?", [id]);

    return WorkoutParameterModel.fromJson(results);
  }

  static Future<List<WorkoutParameterModel>> getAllByWorkoutId(String workoutId) async {
    final results = await database.getAll("SELECT * FROM $table WHERE workoutId = '$workoutId'");

    return results.map((row) => WorkoutParameterModel.fromJson(row)).toList();
  }

  static Stream<List<WorkoutParameterModel>> watch(String workoutId) {
    return database.watch("SELECT * FROM $table WHERE workoutId = $workoutId ORDER BY createdAt DESC").map(//
        (results) => results.map((row) => WorkoutParameterModel.fromJson(row)).toList() //
        );
  }

  static Future<void> create(String workoutId, String name, String value) async {
    await database.execute(
      "INSERT INTO $table (workoutId, name, value, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)",
      [workoutId, name, value, DateTime.now(), DateTime.now()],
    );
  }

  static Future<void> update(String id, String workoutId, String name, String value) async {
    await database.execute(
      "UPDATE $table SET workoutId = ?, name = ?, value = ?, updatedAt = ? WHERE id = ?",
      [workoutId, name, value, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id) async {
    await database.execute("DELETE FROM $table WHERE id = ?", [id]);
  }
}
