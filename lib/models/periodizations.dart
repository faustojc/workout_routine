import 'package:workout_routine/backend/powersync.dart';

class PeriodizationModel {
  static const String table = "periodizations";

  final String id;
  final String name;
  final String? acronym;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  PeriodizationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.acronym,
  });

  static PeriodizationModel? current;
  static List<PeriodizationModel> list = [];

  factory PeriodizationModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return PeriodizationModel(
      id: data['id'],
      name: data['name'],
      acronym: data['acronym'],
      description: data['description'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<PeriodizationModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return PeriodizationModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'acronym': acronym,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<PeriodizationModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $table");

    return results.map((row) => PeriodizationModel.fromJson(row)).toList();
  }

  static Future<PeriodizationModel> getSingle(String id) async {
    final result = await database.get("SELECT * FROM $table WHERE id = $id");

    return PeriodizationModel.fromJson(result);
  }

  static Future<void> create(String name, {String? acronym}) async {
    await database.execute(
      "INSERT INTO $table (name, acronym, createdAt) VALUES (?, ?, ?)",
      [name, acronym, DateTime.now()],
    );
  }

  static Future<void> update(String id, String name, {String? acronym}) async {
    await database.execute(
      "UPDATE $table SET name = ?, acronym = ?, updatedAt = ? WHERE id = ?",
      [name, acronym, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ?",
      [id],
    );
  }
}
