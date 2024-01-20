class PersonalRecordModel {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonalRecordModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  static PersonalRecordModel? current;
  static List<PersonalRecordModel> list = [];

  factory PersonalRecordModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (value is String) && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return PersonalRecordModel(
      id: data['id'],
      userId: data['userId'],
      title: data['title'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<PersonalRecordModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return PersonalRecordModel.fromJson(data);
    }).toList();
  }
}
