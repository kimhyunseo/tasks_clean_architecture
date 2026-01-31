// ignore_for_file: avoid_print

import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/ui/providers.dart';

class TodoListState {
  final List<ToDoEntity> todos;
  final Object? lastCursor;
  final bool isLastPage;
  final bool isLoading;

  TodoListState({
    this.todos = const [],
    this.lastCursor,
    this.isLastPage = false,
    this.isLoading = false,
  });

  TodoListState copyWith({
    List<ToDoEntity>? todos,
    Object? lastCursor,
    bool? isLastPage,
    bool? isLoading,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
      lastCursor: lastCursor ?? this.lastCursor,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TodoListNotifier extends Notifier<TodoListState> {
  late final TodoRepository _repo;
  final int _limit = 15; // 한 번에 가져올 개수

  @override
  TodoListState build() {
    _repo = ref.read(todoRepositoryProvider);
    Future.microtask(() => fetch());
    return TodoListState();
  }

  Future<void> fetch({bool isRefresh = false}) async {
    // 이미 마지막 페이지이거나 로딩 중이면 중단
    if (!isRefresh && (state.isLastPage || state.isLoading)) return;

    state = state.copyWith(isLoading: true);

    try {
      // 새로고침이면 커서를 null로, 아니면 현재 state의 마지막 커서 전달
      final result = await _repo.getToDos(
        limit: _limit,
        lastCursor: isRefresh ? null : state.lastCursor,
      );

      state = state.copyWith(
        todos: isRefresh ? result.todos : [...state.todos, ...result.todos],
        lastCursor: result.lastCursor,
        isLastPage: result.todos.length < _limit,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('데이터 호출 실패: $e');
    }
  }

  /// 할 일 저장
  Future<void> saveTodo({required ToDoEntity todo}) async {
    try {
      final savedTodo = await _repo.addToDo(todo: todo);
      state = state.copyWith(todos: [savedTodo, ...state.todos]);
    } catch (e) {
      print('할 일 저장 실패: $e');
      rethrow;
    }
  }

  /// 할 일 삭제
  Future<void> deleteTodo({required String id}) async {
    try {
      await _repo.deleteToDo(id);

      state = state.copyWith(
        todos: state.todos.where((t) => t.id != id).toList(),
      );
    } catch (e) {
      print('할 일 삭제 실패: $e');
      rethrow;
    }
  }

  /// 할 일 내부 업데이트
  Future<void> _update(ToDoEntity todo) async {
    try {
      await _repo.updateToDo(todo: todo);
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == todo.id ? todo : t).toList(),
      );
    } catch (e) {
      print('업데이트 실패: $e');
      rethrow;
    }
  }

  /// 할 일 수정
  Future<void> editTodo(ToDoEntity todo) => _update(todo);

  Future<void> toggleFavorite(String id) async {
    final todo = state.todos.firstWhere((t) => t.id == id);
    await _update(todo.copyWith(isFavorite: !todo.isFavorite));
  }

  Future<void> toggleDone(String id) async {
    final todo = state.todos.firstWhere((t) => t.id == id);
    await _update(todo.copyWith(isDone: !todo.isDone));
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, TodoListState>(
  () => TodoListNotifier(),
);
