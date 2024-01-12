import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String? userId;
  final double price;
  final String? duration;
  final Timestamp? dateSubscribed;
  final Timestamp? dateExpired;

  Subscription({
    required this.userId,
    required this.price,
    required this.duration,
    required this.dateSubscribed,
    required this.dateExpired,
  });

  static Subscription? current;

  factory Subscription.fromFirestoreDocument(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();

    return Subscription(
      userId: data?['userId'],
      price: data?['price'],
      duration: data?['duration'],
      dateSubscribed: data?['dateSubscribed'],
      dateExpired: data?['dateExpired'],
    );
  }

  factory Subscription.fromFirestoreQuery(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.docs.first.data();

    return Subscription(
      userId: data['userId'],
      price: data['price'],
      duration: data['duration'],
      dateSubscribed: data['dateSubscribed'],
      dateExpired: data['dateExpired'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'price': price,
        'duration': duration,
        'dateSubscribed': dateSubscribed,
        'dateExpired': dateExpired,
      };
}
