import '../entity/todo_entity.dart';

class TodoPageResult {
  final List<ToDoEntity> todos;
  final Object? lastCursor; // Firestore 몰라도 되게

  TodoPageResult({required this.todos, required this.lastCursor});
}
