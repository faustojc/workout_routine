class WeekModel {
  final String id;
  final String periodizationId;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeekModel({
    required this.id,
    required this.periodizationId,
    required this.title,
    this.subtitle,
    required this.createdAt,
    required this.updatedAt,
  });

  static WeekModel? current;
  static List<WeekModel>? list;

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return WeekModel(
      id: data['id'],
      periodizationId: data['periodizationId'],
      title: data['title'],
      subtitle: data['subtitle'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WeekModel> fromJsonList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return WeekModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'periodizationId': periodizationId,
        'title': title,
        'subtitle': subtitle,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
