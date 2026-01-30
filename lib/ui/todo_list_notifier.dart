// ignore_for_file: avoid_print

import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/ui/providers.dart';

class TodoListState {
  final List<ToDoEntity> todos;
  final int page;
  final bool isLastPage;

  TodoListState({
    this.todos = const [],
    this.page = 0,
    this.isLastPage = false,
  });
}

class TodoListNotifier extends Notifier<TodoListState> {
  late final TodoRepository _repo;
  final int _limit = 15; // 한 번에 가져올 개수

  @override
  TodoListState build() {
    _repo = ref.read(todoRepositoryProvider);
    return TodoListState();
  }

  Future<void> fetch({bool isRefresh = false}) async {
    if (!isRefresh && state.isLastPage) return;

    final int targetPage = isRefresh ? 0 : state.page;

    // Repository의 getToDos가 page와 limit을 받는다고 가정 (필요시 레포 수정)
    final newTodos = await _repo.getToDos(page: targetPage, limit: _limit);

    state = TodoListState(
      todos: isRefresh ? newTodos : [...state.todos, ...newTodos],
      page: targetPage + 1,
      isLastPage: newTodos.length < _limit, // 가져온 데이터가 15개 미만이면 마지막 페이지
    );
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
