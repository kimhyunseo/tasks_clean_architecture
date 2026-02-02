// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/data/datasource/todo_data_source.dart';
import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';
import 'package:tasks/domain/entity/todo_statistics.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import '../../domain/entity/todo_entity.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._todoDataSource);
  final TodoDataSource _todoDataSource;

  /// 할 일 목록 보기
  @override
  Future<TodoPageResult> getToDos({int limit = 15, Object? lastCursor}) async {
    try {
      Object? finalCursor = lastCursor;

      // lastCursor가 Entity라면 DTO로 변환
      if (lastCursor is ToDoEntity) {
        finalCursor = ToDoDto(
          id: lastCursor.id,
          title: lastCursor.title,
          description: lastCursor.description,
          isFavorite: lastCursor.isFavorite,
          isDone: lastCursor.isDone,
          createdAt: Timestamp.fromDate(lastCursor.createdAt),
          updatedAt: lastCursor.updatedAt != null
              ? Timestamp.fromDate(lastCursor.updatedAt!)
              : null,
        );
      }

      final todoDtos = await _todoDataSource.getTodos(
        limit: limit,
        lastCursor: finalCursor,
      );

      final todoEntities = todoDtos.map((dto) {
        return ToDoEntity(
          id: dto.id,
          title: dto.title,
          description: dto.description,
          isFavorite: dto.isFavorite,
          isDone: dto.isDone,
          createdAt: dto.createdAt.toDate(),
          updatedAt: dto.updatedAt?.toDate(),
        );
      }).toList();

      return TodoPageResult(
        todos: todoEntities,
        lastCursor: todoEntities.isNotEmpty ? todoEntities.last : null,
        hasMore: todoEntities.length >= limit,
      );
    } catch (e) {
      print('할 일 목록을 불러오는 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 할 일 추가
  @override
  Future<ToDoEntity> addToDo({required ToDoEntity todo}) async {
    try {
      final dto = ToDoDto(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isFavorite: todo.isFavorite,
        isDone: todo.isDone,
        createdAt: Timestamp.fromDate(todo.createdAt),
        updatedAt: null,
      );

      final addedDto = await _todoDataSource.addTodo(dto);
      return todo.copyWith(id: addedDto.id);
    } catch (e) {
      print('할 일 추가 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 할 일 수정
  @override
  Future<void> updateToDo({required ToDoEntity todo}) async {
    try {
      final dto = ToDoDto(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isFavorite: todo.isFavorite,
        isDone: todo.isDone,
        createdAt: Timestamp.fromDate(todo.createdAt),
        updatedAt: Timestamp.now(),
      );

      await _todoDataSource.updateTodo(dto);
    } catch (e) {
      print('할 일 수정 중 오류 발생: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteToDo(String id) async {
    try {
      await _todoDataSource.deleteTodo(id);
    } catch (e) {
      print('할 일 삭제 중 오류 발생: $e');
      rethrow;
    }
  }

  @override
  Future<TodoStatistics> getTodoStatistics() async {
    try {
      final dto = await _todoDataSource.getTodoStatistics();
      return TodoStatistics(total: dto.total, completed: dto.completed);
    } catch (e) {
      print('할 일 통계 불러오는 중 오류 발생: $e');
      rethrow;
    }
  }
}
