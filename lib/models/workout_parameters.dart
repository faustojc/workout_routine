class WorkoutParameterModel {
  final String id;
  final String workoutId;
  final String name;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutParameterModel({
    required this.id,
    required this.workoutId,
    required this.name,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  static WorkoutParameterModel? current;
  static List<WorkoutParameterModel> list = [];

  factory WorkoutParameterModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return WorkoutParameterModel(
      id: data['id'],
      workoutId: data['workoutId'],
      name: data['name'],
      value: data['value'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<WorkoutParameterModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return WorkoutParameterModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutId': workoutId,
        'name': name,
        'value': value,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
