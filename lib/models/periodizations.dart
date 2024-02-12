import 'package:powersync/sqlite3.dart';
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
