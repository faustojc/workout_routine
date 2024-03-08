import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class WeekModel extends BaseModel {
  static const String _table = "weeks";

  final String id;
  final String periodizationId;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeekModel({
    required this.id,
    required this.periodizationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.subtitle,
  });

  static WeekModel? current;
  static List<WeekModel> list = [];

  factory WeekModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return WeekModel(
      id: data['id'],
      periodizationId: data['periodizationId'],
      title: data['title'],
      subtitle: data['subtitle'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WeekModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return WeekModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'periodizationId': periodizationId,
        'title': title,
        'subtitle': subtitle,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<List<WeekModel>> getAll() async {
    final results = await database.getAll("SELECT * FROM $_table");

    return results.map((row) => WeekModel.fromJson(row)).toList();
  }

  static Future<List<WeekModel>> getAllByPeriodizationId(String periodizationId) async {
    final results = await database.getAll("SELECT * FROM $_table WHERE periodizationId = '$periodizationId'");

    return results.map((row) => WeekModel.fromJson(row)).toList();
  }

  static Future<WeekModel> getSingle(String id) async {
    final result = await database.get("SELECT * FROM $_table WHERE id = '$id'");

    return WeekModel.fromJson(result);
  }

  @override
  // TODO: implement tableName
  String get tableName => _table;
}
