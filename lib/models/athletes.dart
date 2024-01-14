class AthleteModel {
  final String id;
  final String userId;
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
  });

  static AthleteModel? current;

  factory AthleteModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'birthday' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return AthleteModel(
      id: data['id'],
      userId: data['userId'],
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
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
