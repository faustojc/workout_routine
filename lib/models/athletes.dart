import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class AthleteModel extends BaseModel {
  static const String _table = "athletes";

  final String id;
  final String userId;
  final String? categoryId;
  final String firstName;
  final String lastName;
  final String sex;
  final String city;
  final String address;
  final int age;
  final num weight;
  final num height;
  final DateTime birthday;
  final DateTime createdAt;
  final DateTime updatedAt;

  AthleteModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.city,
    required this.address,
    required this.age,
    required this.weight,
    required this.height,
    required this.birthday,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
  });

  static AthleteModel? current;
  static List<AthleteModel> list = [];

  factory AthleteModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'birthday' || key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return AthleteModel(
      id: data['id'],
      userId: data['userId'],
      categoryId: data['categoryId'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      sex: data['sex'],
      city: data['city'],
      address: data['address'],
      age: data['age'],
      weight: data['weight'],
      height: data['height'],
      birthday: data['birthday'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<AthleteModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'birthday' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return AthleteModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'categoryId': categoryId,
        'firstName': firstName,
        'lastName': lastName,
        'sex': sex,
        'city': city,
        'address': address,
        'age': age,
        'weight': weight,
        'height': height,
        'birthdate': birthday,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Future<AthleteModel> getSingle(String id) async {
    final results = await database.get("SELECT * FROM $_table WHERE id = ?", [id]);

    return AthleteModel.fromJson(results);
  }

  static Future<AthleteModel> getByUserId(String userId) async {
    final results = await database.get("SELECT * FROM $_table WHERE userId = ?", [userId]);

    return AthleteModel.fromJson(results);
  }

  static Stream<List<AthleteModel>> watch(String userId) {
    return database.watch("SELECT * FROM $_table WHERE userId = ? ORDER BY createdAt DESC", parameters: [userId]).map(//
        (results) => results.map((row) => AthleteModel.fromJson(row)).toList() //
        );
  }

  @override
  String get tableName => _table;
}
