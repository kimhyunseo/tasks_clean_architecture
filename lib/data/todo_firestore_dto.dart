import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoDto {
  final String id;
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  ToDoDto({
    required this.id,
    required this.title,
    this.description,
    required this.isFavorite,
    required this.isDone,
    required this.createdAt,
    this.updatedAt,
  });

  factory ToDoDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ToDoDto(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      isFavorite: (data['isFavorite'] as bool?) ?? false,
      isDone: (data['isDone'] as bool?) ?? false,
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
      'isDone': isDone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
