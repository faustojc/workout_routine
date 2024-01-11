import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String userId;
  final String description;
  final String price;
  final String duration;
  final String type;
  final Timestamp dateSubscribed;

  Subscription({
    required this.userId,
    required this.description,
    required this.price,
    required this.duration,
    required this.type,
    required this.dateSubscribed,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['userId'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      type: json['type'],
      dateSubscribed: json['dateSubscribed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'description': description,
        'price': price,
        'duration': duration,
        'type': type,
        'dateSubscribed': dateSubscribed,
      };
}
