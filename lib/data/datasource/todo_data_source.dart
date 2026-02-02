// lib/data/datasource/todo_data_source.dart

import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/data/dto/todo_statistics_dto.dart';

abstract interface class TodoDataSource {
  Future<List<ToDoDto>> getTodos({int limit = 15, Object? lastCursor});
  Future<ToDoDto> addTodo(ToDoDto todo);
  Future<void> updateTodo(ToDoDto todo);
  Future<void> deleteTodo(String id);
  Future<TodoStatisticsDto> getTodoStatistics();
}
