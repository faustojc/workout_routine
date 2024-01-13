import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalRecord {
  final String userId;
  final String title;
  final double weight;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  PersonalRecord({
    required this.userId,
    required this.title,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<PersonalRecord?> current = [];

  factory PersonalRecord.fromFirestoreDocument(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();

    return PersonalRecord(
      userId: data?['userId'],
      title: data?['title'],
      weight: data?['weight'],
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
    );
  }

  static List<PersonalRecord> fromFirestoreQuery(QuerySnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    return snapshot.docs.map((doc) => PersonalRecord.fromFirestoreDocument(doc, options)).toList();
  }
}
