import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class PRHistoryModel extends BaseModel {
  static const String _table = "personal_records_history";

  final String id;
  final String prId;
  final String userId;
  final num weight;
  final DateTime createdAt;

  PRHistoryModel({
    required this.id,
    required this.prId,
    required this.userId,
    required this.weight,
    required this.createdAt,
  });

  static PRHistoryModel? current;
  static List<PRHistoryModel> list = [];

  factory PRHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt') ? DateTime.parse(value) : value));

    return PRHistoryModel(
      id: data['id'],
      prId: data['prId'],
      userId: data['userId'],
      weight: data['weight'],
      createdAt: data['createdAt'],
    );
  }

  static List<PRHistoryModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' ? DateTime.parse(value) : value));

      return PRHistoryModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prId': prId,
        'userId': userId,
        'weight': weight,
        'createdAt': createdAt,
      };

  static Future<List<PRHistoryModel>> getAllByUserId(String userId) async {
    final results = await database.getAll("SELECT * FROM $_table WHERE userId = ? ORDER BY createdAt DESC", [userId]);

    return PRHistoryModel.fromList(results);
  }

  static Future<PRHistoryModel> getSingle(String id, String prId, String userId) async {
    final results = await database.get("SELECT * FROM $_table WHERE id = ? AND prId = ? AND userId = ?", [id, prId, userId]);

    return PRHistoryModel.fromJson(results);
  }

  static Stream<List<PRHistoryModel>> watch(String userId) {
    return database.watch("SELECT * FROM $_table WHERE userId = $userId ORDER BY createdAt DESC").map(//
        (results) => results.map((row) => PRHistoryModel.fromJson(row)).toList() //
        );
  }

  @override
  // TODO: implement tableName
  String get tableName => _table;
}
