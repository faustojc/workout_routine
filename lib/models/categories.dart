class CategoryModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  static CategoryModel? current;
  static List<CategoryModel> list = [];

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, value is String && (key == 'createdAt' || key == 'updatedAt') ? DateTime.parse(value) : value));

    return CategoryModel(
      id: data['id'],
      name: data['name'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<CategoryModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return CategoryModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
