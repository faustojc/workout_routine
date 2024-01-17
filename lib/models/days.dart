class DayModel {
  final String id;
  final String weekId;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  DayModel({
    required this.id,
    required this.weekId,
    required this.title,
    this.subtitle,
    required this.createdAt,
    required this.updatedAt,
  });

  static DayModel? current;
  static List<DayModel> list = [];

  factory DayModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return DayModel(
      id: data['id'],
      weekId: data['weekId'],
      title: data['title'],
      subtitle: data['subtitle'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<DayModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return DayModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'weekId': weekId,
        'title': title,
        'subtitle': subtitle,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
