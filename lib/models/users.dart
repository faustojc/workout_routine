class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String country;
  final String city;
  final String address;
  final String email;
  final String password;
  final num age;
  final num weight;
  final DateTime birthdate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Tokens? tokens;

  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.city,
    required this.address,
    required this.email,
    required this.password,
    required this.age,
    required this.weight,
    required this.birthdate,
    required this.createdAt,
    required this.updatedAt,
    this.tokens,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        country: json['country'],
        city: json['city'],
        address: json['address'],
        email: json['email'],
        password: json['password'],
        age: json['age'],
        weight: json['weight'],
        birthdate: json['birthdate'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        tokens: Tokens.fromJson(json['tokens']));
  }
}

class Tokens {
  final String? authToken;
  final String? verificationToken;
  final DateTime? createdAt;

  Tokens({this.createdAt, this.authToken, this.verificationToken});

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      authToken: json['authToken'],
      verificationToken: json['verificationToken'],
      createdAt: json['createdAt'],
    );
  }
}
