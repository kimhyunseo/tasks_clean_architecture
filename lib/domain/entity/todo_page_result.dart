import '../entity/todo_entity.dart';

class TodoPageResult {
  final List<ToDoEntity> todos;
  final Object? lastCursor;
  final bool hasMore;

  TodoPageResult({
    required this.todos,
    required this.lastCursor,
    this.hasMore = false,
  });
}
