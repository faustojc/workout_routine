import 'package:workout_routine/backend/powersync.dart';

class SubscriptionModel {
  static const String table = 'subscriptions';

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
    final results = await database.get("SELECT * FROM $table WHERE id = ? AND userId = ?", [id, userId]);

    return SubscriptionModel.fromJson(results);
  }

  static Future<SubscriptionModel> getSingleByUserId(String userId) async {
    final results = await database.get("SELECT * FROM $table WHERE userId = ?", [userId]);

    return SubscriptionModel.fromJson(results);
  }

  static Future<SubscriptionModel> watch(String userId) async {
    final result = await database.watch("SELECT * FROM $table WHERE userId = ? LIMIT 1", parameters: [userId]).first.then((value) => value.first);

    return SubscriptionModel.fromJson(result);
  }

  static Future<void> create(String userId, num price, String duration) async {
    await database.execute(
      "INSERT INTO $table (userId, isSubscribed, price, duration, dateSubscribed, dateExpired) VALUES (?, ?, ?, ?, ?, ?)",
      [userId, true, price, duration, DateTime.now(), DateTime.now().add(const Duration(days: 30))],
    );
  }

  static Future<void> update(String id, String userId, bool isSubscribed, num price, String duration, DateTime dateSubscribed, DateTime dateExpired) async {
    await database.execute(
      "UPDATE $table SET isSubscribed = ?, price = ?, duration = ?, dateSubscribed = ?, dateExpired = ? WHERE id = ? AND userId = ?",
      [isSubscribed, price, duration, dateSubscribed, dateExpired, id, userId],
    );
  }

  static Future<void> delete(String id, String userId) async {
    await database.execute(
      "DELETE FROM $table WHERE id = ? AND userId = ?",
      [id, userId],
    );
  }
}
