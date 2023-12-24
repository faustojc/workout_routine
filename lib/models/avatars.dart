class Avatar {
  final String id;
  final String url;
  final String createdAt;
  final String updatedAt;

  Avatar({
    required this.id,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      url: json['url'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
