import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/models/base_model.dart';

class SubscriptionModel extends BaseModel {
  static const String _table = "subscriptions";

  final String id;
  final String userId;
  final bool isSubscribed;
  final num? price;
  final String? duration;
  final DateTime? dateSubscribed;
  final DateTime? dateExpired;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.price,
    required this.duration,
    required this.dateSubscribed,
    required this.dateExpired,
    this.isSubscribed = false,
  });

  static SubscriptionModel? current;

  factory SubscriptionModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) {
      if (key == 'isSubscribed' && value is int) {
        return MapEntry(key, value == 1 ? true : false);
      }

      if ((key == 'dateSubscribed' && value != null) || (key == 'dateExpired' && value != null)) {
        return MapEntry(key, DateTime.parse(value));
      } else {
        return MapEntry(key, value);
      }
    });

    return SubscriptionModel(
      id: data['id'],
      userId: data['userId'],
      isSubscribed: data['isSubscribed'],
      price: data['price'],
      duration: data['duration'],
      dateSubscribed: data['dateSubscribed'],
      dateExpired: data['dateExpired'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'isSubscribed': isSubscribed,
        'price': price,
        'duration': duration,
        'dateSubscribed': dateSubscribed,
        'dateExpired': dateExpired,
      };

  static Future<SubscriptionModel> getSingle(String id, String userId) async {
    final results = await database.get("SELECT * FROM $_table WHERE id = ? AND userId = ?", [id, userId]);

    return SubscriptionModel.fromJson(results);
  }

  static Future<SubscriptionModel> getSingleByUserId(String userId) async {
    final results = await database.get("SELECT * FROM $_table WHERE userId = ?", [userId]);

    return SubscriptionModel.fromJson(results);
  }

  static Future<SubscriptionModel> watch(String userId) async {
    final result = await database.watch("SELECT * FROM $_table WHERE userId = ? LIMIT 1", parameters: [userId]).first.then((value) => value.first);

    return SubscriptionModel.fromJson(result);
  }

  @override
  String get tableName => _table;
}
