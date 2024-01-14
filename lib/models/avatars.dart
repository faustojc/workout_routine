class Avatar {
  final String id;
  final String url;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Avatar({
    required this.id,
    required this.url,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return Avatar(
      id: data['id'],
      url: data['url'],
      userId: data['userId'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'athleteId': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
