class PeriodizationModel {
  final String id;
  final String name;
  final String? acronym;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  PeriodizationModel({
    required this.id,
    required this.name,
    this.acronym,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  static PeriodizationModel? current;
  static List<PeriodizationModel> list = [];

  factory PeriodizationModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return PeriodizationModel(
      id: data['id'],
      name: data['name'],
      acronym: data['acronym'],
      description: data['description'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<PeriodizationModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return PeriodizationModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'acronym': acronym,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
