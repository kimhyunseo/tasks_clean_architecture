// ignore_for_file: avoid_print

import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/ui/providers.dart';

class TodoListNotifier extends Notifier<List<ToDoEntity>> {
  late final TodoRepository _repo;

  @override
  List<ToDoEntity> build() {
    _repo = ref.read(todoRepositoryProvider);
    fetch();
    return [];
  }

  Future<void> fetch() async {
    state = await _repo.getToDos();
  }

  /// 할 일 저장
  Future<void> saveTodo({required ToDoEntity todo}) async {
    try {
      final savedTodo = await _repo.addToDo(todo: todo);
      state = [...state, savedTodo];
    } catch (e) {
      print('할 일 저장 실패: $e');
      rethrow;
    }
  }

  /// 할 일 삭제
  Future<void> deleteTodo({required String id}) async {
    try {
      await _repo.deleteToDo(id);

      state = state.where((t) => t.id != id).toList();
    } catch (e) {
      print('할 일 삭제 실패: $e');
      rethrow;
    }
  }

  /// 할 일 내부 업데이트
  Future<void> _update(ToDoEntity todo) async {
    try {
      await _repo.updateToDo(todo: todo);
      state = state.map((t) {
        if (t.id == todo.id) {
          return todo;
        } else {
          return t;
        }
      }).toList();
    } catch (e) {
      print('업데이트 실패: $e');
      rethrow;
    }
  }

  /// 할 일 수정
  Future<void> editTodo(ToDoEntity todo) => _update(todo);

  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String id) async {
    final todo = state.firstWhere((t) => t.id == id);
    await _update(todo.copyWith(isFavorite: !todo.isFavorite));
  }

  /// 완료 토글
  Future<void> toggleDone(String id) async {
    final todo = state.firstWhere((t) => t.id == id);
    await _update(todo.copyWith(isDone: !todo.isDone));
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<ToDoEntity>>(
  () => TodoListNotifier(),
);
