import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';

abstract class TodoRepository {
  Future<TodoPageResult> getToDos({int limit, Object? lastCursor});
  Future<ToDoEntity> addToDo({required ToDoEntity todo});
  Future<void> updateToDo({required ToDoEntity todo});
  Future<void> deleteToDo(String id);
}
