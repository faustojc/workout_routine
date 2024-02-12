import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/backend/powersync.dart';

class AthleteModel {
  static const String table = "athletes";

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
    final results = await database.get("SELECT * FROM $table WHERE id = ?", [id]);

    return AthleteModel.fromJson(results);
  }

  static Future<AthleteModel> getByUserId(String userId) async {
    final results = await database.get("SELECT * FROM $table WHERE userId = ?", [userId]);

    return AthleteModel.fromJson(results);
  }

  static Stream<List<AthleteModel>> watch(String userId) {
    return database.watch("SELECT * FROM $table WHERE userId = ? ORDER BY createdAt DESC", parameters: [userId]).map(//
        (results) => results.map((row) => AthleteModel.fromJson(row)).toList() //
        );
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
