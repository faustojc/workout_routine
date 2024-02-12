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
  'sex': '',
  'age': '',
  'weight': '',
  'height': '',
  'birthday': '',
  'city': '',
  'address': '',
};
