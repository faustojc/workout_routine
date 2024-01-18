class AthleteModel {
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
    this.categoryId,
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
  });

  static AthleteModel? current;
  static List<AthleteModel> list = [];

  factory AthleteModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'birthday' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'birthday' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

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
}
