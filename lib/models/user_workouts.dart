class UserWorkoutModel {
  final String id;
  final String userId;
  final String workoutId;
  final DateTime playedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserWorkoutModel({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.playedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserWorkoutModel? current;
  static List<UserWorkoutModel> list = [];

  factory UserWorkoutModel.fromJson(Map<String, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'playedAt' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

    return UserWorkoutModel(
      id: data['id'],
      userId: data['userId'],
      workoutId: data['workoutId'],
      playedAt: data['playedAt'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  static List<UserWorkoutModel> fromList(List<dynamic> json) {
    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'playedAt' || key == 'createdAt' || key == 'updatedAt' ? DateTime.parse(value) : value));

      return UserWorkoutModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'workoutId': workoutId,
        'playedAt': playedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
