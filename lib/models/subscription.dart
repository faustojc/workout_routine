class SubscriptionModel {
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
    this.isSubscribed = false,
    required this.price,
    required this.duration,
    required this.dateSubscribed,
    required this.dateExpired,
  });

  static SubscriptionModel? current;

  factory SubscriptionModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) {
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
}
