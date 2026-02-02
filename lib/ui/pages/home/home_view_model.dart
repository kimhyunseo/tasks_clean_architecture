// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/entity/todo_statistics.dart';
import 'package:tasks/ui/todo_list_notifier.dart';

class HomeState {
  final List<ToDoEntity> todos;
  final bool isLoading;
  final TodoStatistics statistics;
  HomeState({
    required this.todos,
    this.isLoading = false,
    required this.statistics,
  });

  HomeState copyWith({
    List<ToDoEntity>? todos,
    bool? isLoading,
    TodoStatistics? statistics,
  }) {
    return HomeState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      statistics: statistics ?? this.statistics,
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
class HomeToggleDone extends HomeEvent {
  final String id;
  HomeToggleDone(this.id);
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    final todoListState = ref.watch(todoListProvider);
    return HomeState(
      todos: todoListState.todos,
      isLoading: todoListState.isLoading,
      statistics: todoListState.statistics,
    );
  }

  Future<void> onEvent(HomeEvent event) async {
    final todoListNotifier = ref.read(todoListProvider.notifier);

    try {
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

        case HomeToggleDone(id: final id):
          await todoListNotifier.toggleDone(id);
      }
    } catch (e) {
      print('HomeViewModel 이벤트 처리 중 에러 발생: $e');
    }
  }
}

final homeViewModel = NotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
