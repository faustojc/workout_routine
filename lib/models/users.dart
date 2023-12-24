import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_routine/models/avatars.dart';

class Athlete {
  final String id;
  final String firstName;
  final String lastName;
  final String country;
  final String city;
  final String address;
  final num age;
  final num weight;
  final DateTime birthdate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final Avatar? avatar;
  final Tokens? tokens;

  Athlete({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.city,
    required this.address,
    required this.age,
    required this.weight,
    required this.birthdate,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.avatar,
    this.tokens,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        country: json['country'],
        city: json['city'],
        address: json['address'],
        age: json['age'],
        weight: json['weight'],
        birthdate: json['birthdate'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        user: json['user'],
        avatar: Avatar.fromJson(json['avatar']),
        tokens: Tokens.fromJson(json['tokens']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'city': city,
        'address': address,
        'age': age,
        'weight': weight,
        'birthdate': birthdate,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'user': user,
        'avatar': avatar,
        'tokens': tokens,
      };
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
