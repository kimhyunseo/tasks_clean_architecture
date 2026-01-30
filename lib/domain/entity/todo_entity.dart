class ToDoEntity {
  final String id;
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ToDoEntity({
    required this.id,
    required this.title,
    this.description,
    this.isFavorite = false,
    this.isDone = false,
    required this.createdAt,
    this.updatedAt,
  });

  ToDoEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    bool? isDone,
    DateTime? updatedAt,
  }) {
    return ToDoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
