class Athlete {
  late String? id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String gender;
  final String country;
  final String city;
  final String address;
  final num age;
  final num weight;
  final DateTime birthday;
  final DateTime createdAt;
  final DateTime updatedAt;

  Athlete({
    this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.country,
    required this.city,
    required this.address,
    required this.age,
    required this.weight,
    required this.birthday,
    required this.createdAt,
    required this.updatedAt,
  });

  static Athlete? current;

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        country: json['country'],
        city: json['city'],
        address: json['address'],
        age: json['age'],
        weight: json['weight'],
        birthday: json['birthday'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'country': country,
        'city': city,
        'address': address,
        'age': age,
        'weight': weight,
        'birthdate': birthday,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
