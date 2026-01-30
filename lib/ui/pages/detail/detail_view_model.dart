// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/ui/todo_list_notifier.dart';

class DetailState {
  final ToDoEntity? todo;
  final bool isLoading;

  DetailState({this.todo, this.isLoading = false});

  DetailState copyWith({ToDoEntity? todo, bool? isLoading}) {
    return DetailState(
      todo: todo ?? this.todo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

sealed class DetailEvent {
  const DetailEvent();
}

class DetailEditTodo extends DetailEvent {
  final ToDoEntity todo;
  DetailEditTodo(this.todo);
}

class DetailDeleteTodo extends DetailEvent {}

class DetailToggleFavorite extends DetailEvent {}

class DetailToggleDone extends DetailEvent {}

class DetailFetchRequested extends DetailEvent {}

// view model

class DetailViewModel extends Notifier<DetailState> {
  final String id;

  DetailViewModel(this.id);

  @override
  DetailState build() {
    final todo = ref.watch(todoListProvider);
    return DetailState(
      todo: todo.where((todo) => todo.id == id).firstOrNull,
      isLoading: false,
    );
  }

  Future<void> onEvent(DetailEvent event) async {
    if (state.todo == null) return;

    final todoListNotifier = ref.read(todoListProvider.notifier);
    final currentTodo = state.todo!;

    switch (event) {
      case DetailEditTodo(todo: final updatedTodo):
        await todoListNotifier.editTodo(updatedTodo);

      case DetailDeleteTodo():
        await todoListNotifier.deleteTodo(id: currentTodo.id);

      case DetailToggleFavorite():
        await todoListNotifier.toggleFavorite(currentTodo.id);

      case DetailToggleDone():
        await todoListNotifier.toggleDone(currentTodo.id);

      case DetailFetchRequested():
        await todoListNotifier.fetch();
    }

    state = DetailState(todo: state.todo, isLoading: false);
  }
}

final detailViewModelProvider =
    NotifierProvider.family<DetailViewModel, DetailState, String>(
      (id) => DetailViewModel(id),
    );
