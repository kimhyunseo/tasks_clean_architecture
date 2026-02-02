import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';
import 'package:tasks/domain/entity/todo_statistics.dart';

abstract interface class TodoRepository {
  Future<TodoPageResult> getToDos({int limit, Object? lastCursor});
  Future<ToDoEntity> addToDo({required ToDoEntity todo});
  Future<void> updateToDo({required ToDoEntity todo});
  Future<void> deleteToDo(String id);
  Future<TodoStatistics> getTodoStatistics();
}
