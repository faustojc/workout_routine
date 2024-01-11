import 'package:cloud_firestore/cloud_firestore.dart';

final Map<String, dynamic> athleteInfo = {
  'userId': '',
  'email': '',
  'password': '',
  'firstName': '',
  'lastName': '',
  'gender': '',
  'age': '',
  'weight': '',
  'height': '',
  'birthday': '',
  'city': '',
  'address': '',
  'createdAt': Timestamp.now(),
  'updatedAt': Timestamp.now(),
};

final Map<String, dynamic> avatarInfo = {
  'url': '',
  'userId': '',
  'createdAt': Timestamp.now(),
  'updatedAt': Timestamp.now(),
};

final Map<String, dynamic> subscriptionInfo = {
  'athleteId': '',
  'description': '',
  'price': '',
  'duration': '',
  'type': '',
  'dateSubscribed': '',
};
