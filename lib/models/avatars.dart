class Avatar {
  final String url;
  final String userId;
  final String createdAt;
  final String updatedAt;

  Avatar({
    required this.url,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      url: json['url'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'athleteId': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
