class PRHistoryModel {
  final String id;
  final String prId;
  final String userId;
  final double weight;
  final DateTime createdAt;

  PRHistoryModel({
    required this.id,
    required this.prId,
    required this.userId,
    required this.weight,
    required this.createdAt,
  });

  static PRHistoryModel? current;
  static List<PRHistoryModel> list = [];

  factory PRHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    final data = json.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' ? DateTime.parse(value) : value));

    return PRHistoryModel(
      id: data['id'],
      prId: data['prId'],
      userId: data['userId'],
      weight: data['weight'],
      createdAt: data['createdAt'],
    );
  }

  static List<PRHistoryModel> fromList(List<dynamic>? json) {
    if (json == null) return [];

    return json.map((e) {
      final data = e.map((key, value) => MapEntry(key, (key is! DateTime) && key == 'createdAt' ? DateTime.parse(value) : value));

      return PRHistoryModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prId': prId,
        'userId': userId,
        'weight': weight,
        'createdAt': createdAt,
      };
}
