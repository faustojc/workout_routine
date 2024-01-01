class Athlete {
  late String? userId;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String gender;
  final String city;
  final String address;
  final String age;
  final String weight;
  final DateTime birthday;
  final DateTime createdAt;
  final DateTime updatedAt;

  Athlete({
    this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gender,
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
        userId: json['userId'],
        email: json['email'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        city: json['city'],
        address: json['address'],
        age: json['age'],
        weight: json['weight'],
        birthday: json['birthday'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'city': city,
        'address': address,
        'age': age,
        'weight': weight,
        'birthdate': birthday,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
