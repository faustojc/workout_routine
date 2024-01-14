import 'package:supabase_flutter/supabase_flutter.dart';

late SupabaseClient supabase;
late Session session;
late User user;

final Map<String, dynamic> userInfo = {
  'email': '',
  'password': '',
};

final Map<String, dynamic> athleteInfo = {
  'userId': '',
  'firstName': '',
  'lastName': '',
  'gender': '',
  'age': '',
  'weight': '',
  'height': '',
  'birthday': '',
  'city': '',
  'address': '',
};

final Map<String, dynamic> avatarInfo = {
  'url': '',
  'userId': '',
};

final Map<String, dynamic> subscriptionInfo = {
  'athleteId': '',
  'description': '',
  'price': '',
  'duration': '',
  'type': '',
  'dateSubscribed': '',
  'dateExpired': '',
};
