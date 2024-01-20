class Workouts {
  final String id;
  final String daysId;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String? createdAt;
  final String? updatedAt;

  Workouts({
    required this.id,
    required this.daysId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.createdAt,
    this.updatedAt,
  });

  static Workouts? current;
  static List<Workouts> list = [];

  factory Workouts.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return Workouts(
      id: data['id'],
      daysId: data['daysId'],
      title: data['title'],
      description: data['description'],
      videoUrl: data['video_url'],
      thumbnailUrl: data['thumbnail_url'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }

  static List<Workouts> fromJsonList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return Workouts.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'daysId': daysId,
        'title': title,
        'description': description,
        'video_url': videoUrl,
        'thumbnail_url': thumbnailUrl,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
