// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/ui/todo_list_notifier.dart';

class HomeState {
  final List<ToDoEntity> todos;
  final bool isLoading;
  HomeState({required this.todos, this.isLoading = false});

  HomeState copyWith({List<ToDoEntity>? todos, bool? isLoading}) {
    return HomeState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

sealed class HomeEvent {
  const HomeEvent();
}

/// 할 일 가져오기
class HomeFetchRequested extends HomeEvent {}

/// 새로고침
class HomeRefreshRequested extends HomeEvent {}

/// 할 일 추가
class HomeAddTodo extends HomeEvent {
  final ToDoEntity todo;
  HomeAddTodo(this.todo);
}

/// 할 일 삭제
class HomeDeleteTodo extends HomeEvent {
  final String id;
  HomeDeleteTodo(this.id);
}

/// 할 일 수정
class HomeEditTodo extends HomeEvent {
  final ToDoEntity todo;
  HomeEditTodo(this.todo);
}

/// 즐겨찾기 토글
class HomeToggleFavorite extends HomeEvent {
  final String id;
  HomeToggleFavorite(this.id);
}

/// 완료 토글
class HomeToggleDoneRequested extends HomeEvent {
  final String id;
  HomeToggleDoneRequested(this.id);
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    final todoListState = ref.watch(todoListProvider);
    return HomeState(
      todos: todoListState.todos,
      isLoading: todoListState.isLoading,
    );
  }

  Future<void> onEvent(HomeEvent event) async {
    final todoListNotifier = ref.read(todoListProvider.notifier);

    switch (event) {
      case HomeFetchRequested():
        await todoListNotifier.fetch(isRefresh: false);

      case HomeRefreshRequested():
        await todoListNotifier.fetch(isRefresh: true);

      case HomeAddTodo(todo: final todo):
        await todoListNotifier.saveTodo(todo: todo);

      case HomeDeleteTodo(id: final id):
        await todoListNotifier.deleteTodo(id: id);

      case HomeEditTodo(todo: final todo):
        await todoListNotifier.editTodo(todo);

      case HomeToggleFavorite(id: final id):
        await todoListNotifier.toggleFavorite(id);

      case HomeToggleDoneRequested(id: final id):
        await todoListNotifier.toggleDone(id);
    }

    state = state.copyWith(isLoading: false);
  }
}

final homeViewModel = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
