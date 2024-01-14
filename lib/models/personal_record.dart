class PersonalRecordModel {
  final String id;
  final String userId;
  final String title;
  final num weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonalRecordModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<PersonalRecordModel?> list = [];

  static List<PersonalRecordModel> fromJson(List<dynamic> json) {
    final list = <PersonalRecordModel>[];

    for (var info in json) {
      final data = info.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      list.add(PersonalRecordModel(
        id: data['id'],
        userId: data['userId'],
        title: data['title'],
        weight: data['weight'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
      ));
    }

    return list;
  }
}
