import 'package:workout_routine/backend/powersync.dart';

class AthleteModel {
  static const String tableName = "athletes";

  final String id;
  final String userId;
  final String? categoryId;
  final String firstName;
  final String lastName;
  final String gender;
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
    required this.gender,
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
    final data = json.map((key, value) => MapEntry(key, key == 'birthday' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return AthleteModel(
      id: data['id'],
      userId: data['userId'],
      categoryId: data['categoryId'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
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
        'gender': gender,
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
    final results = await database.get("SELECT * FROM $tableName WHERE id = ?", [id]);

    return AthleteModel.fromJson(results);
  }

  static Future<AthleteModel> getByUserId(String userId) async {
    final results = await database.get("SELECT * FROM $tableName WHERE userId = ?", [userId]);

    return AthleteModel.fromJson(results);
  }

  static Stream<List<AthleteModel>> watch(String userId) {
    return database.watch("SELECT * FROM $tableName WHERE userId = ? ORDER BY createdAt DESC", parameters: [userId]).map(//
        (results) => results.map((row) => AthleteModel.fromJson(row)).toList() //
        );
  }

  static Future<void> create(String firstName, String lastName, String gender, String city, String address, int age, num weight, num height, DateTime birthday) async {
    await database.execute(
      "INSERT INTO $tableName (firstName, lastName, gender, city, address, age, weight, height, birthday, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [firstName, lastName, gender, city, address, age, weight, height, birthday, DateTime.now()],
    );
  }

  static Future<void> update(String id, String firstName, String lastName, String gender, String city, String address, int age, num weight, num height, DateTime birthday) async {
    await database.execute(
      "UPDATE $tableName SET firstName = ?, lastName = ?, gender = ?, city = ?, address = ?, age = ?, weight = ?, height = ?, birthday = ?, updatedAt = ? WHERE id = ?",
      [firstName, lastName, gender, city, address, age, weight, height, birthday, DateTime.now(), id],
    );
  }

  static Future<void> delete(String id, String userId) async {
    await database.execute(
      "DELETE FROM $tableName WHERE id = ? AND userId = ?",
      [id, userId],
    );
  }
}
