import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String height;
  final bool isSubscribed;
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
    required this.height,
    required this.birthday,
    required this.createdAt,
    required this.updatedAt,
    this.isSubscribed = false,
  });

  static Athlete? current;

  factory Athlete.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();

    return Athlete(
      userId: data?['userId'],
      email: data?['email'],
      password: data?['password'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      gender: data?['gender'],
      city: data?['city'],
      address: data?['address'],
      age: data?['age'],
      weight: data?['weight'],
      height: data?['height'],
      isSubscribed: data?['isSubscribed'],
      birthday: data?['birthday'],
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
    );
  }

  factory Athlete.fromFireStore(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.docs.first.data();

    return Athlete(
      userId: data['userId'],
      email: data['email'],
      password: data['password'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
      city: data['city'],
      address: data['address'],
      age: data['age'],
      weight: data['weight'],
      height: data['height'],
      isSubscribed: data['isSubscribed'],
      birthday: data['birthday'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

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
      height: json['height'],
      isSubscribed: json['isSubscribed'],
      birthday: json['birthday'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
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
        'height': height,
        'isSubscribed': isSubscribed,
        'birthdate': birthday,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
