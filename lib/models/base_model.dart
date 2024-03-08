import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

abstract class BaseModel {
  String get tableName;

  Future<ResultSet?> create(Map<String, dynamic> fields) async {
    if (fields.isEmpty) return null;

    Map<String, dynamic> data = {
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    List<String> placeholders = [];

    fields.forEach((key, value) {
      value = ((key == 'createdAt' || key == 'updatedAt') && value is DateTime) ? value.toIso8601String() : value;

      data.addAll({key: value});
      placeholders.add("?");
    });

    String sql = "INSERT INTO $tableName (${data.keys.toList().join(', ')}) VALUES (${placeholders.join(', ')})";

    return await database.execute(sql, data.values.toList());
  }

  Future<ResultSet?> update(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return null;

    List<String> updates = [];
    List<dynamic> values = [];

    fields.forEach((key, value) {
      updates.add("$key = ?");
      values.add(value);
    });

    String sql = "UPDATE $tableName SET ${updates.join(', ')} WHERE id = ?";
    values.add(id);

    return await database.execute(sql, values);
  }

  Future<ResultSet> delete(String id) async {
    return await database.execute("DELETE FROM $tableName WHERE id = ?", [id]);
  }
}
