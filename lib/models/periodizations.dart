import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class PeriodizationModel extends BaseModel {
  static const String _table = "periodizations";

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
    final results = await database.getAll("SELECT * FROM $_table");

    return results.map((row) => PeriodizationModel.fromJson(row)).toList();
  }

  static Future<PeriodizationModel> getSingle(String id) async {
    final result = await database.get("SELECT * FROM $_table WHERE id = $id");

    return PeriodizationModel.fromJson(result);
  }

  @override
  String get tableName => throw UnimplementedError();
}
