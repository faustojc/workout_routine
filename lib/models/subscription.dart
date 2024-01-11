class Subscription {
  final String id;
  final String athleteId;
  final String description;
  final String price;
  final String duration;
  final String type;

  Subscription({
    required this.id,
    required this.athleteId,
    required this.description,
    required this.price,
    required this.duration,
    required this.type,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      athleteId: json['athleteId'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'athleteId': athleteId,
        'description': description,
        'price': price,
        'duration': duration,
        'type': type,
      };
}