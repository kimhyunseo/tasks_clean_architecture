import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';
import 'package:tasks/domain/entity/todo_statistics.dart';
import 'package:tasks/domain/repository/todo_repository.dart';

class TodoRepositoryMock implements TodoRepository {
  // Mock 데이터 리스트 (최신순 정렬 가정)
  final List<ToDoEntity> _mockData = List.generate(
    1000,
    (i) => ToDoEntity(
      id: '$i',
      title: '할 일 $i',
      description: '설명 $i',
      isDone: false,
      isFavorite: false,
      createdAt: DateTime.now().subtract(Duration(minutes: i)),
    ),
  );

  @override
  Future<TodoPageResult> getToDos({int limit = 15, Object? lastCursor}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lastIndex = lastCursor is ToDoEntity
        ? _mockData.indexWhere((e) => e.id == lastCursor.id)
        : -1;

    final startIndex = lastIndex + 1;
    final results = _mockData.skip(startIndex).take(limit).toList();

    return TodoPageResult(
      todos: results,
      lastCursor: results.isNotEmpty ? results.last : null,
      hasMore: startIndex + limit < _mockData.length,
    );
  }

  @override
  Future<ToDoEntity> addToDo({required ToDoEntity todo}) async {
    final newTodo = todo.copyWith(id: DateTime.now().toIso8601String());
    _mockData.insert(0, newTodo); // 맨 앞에 추가
    return newTodo;
  }

  @override
  Future<void> updateToDo({required ToDoEntity todo}) async {
    final index = _mockData.indexWhere((e) => e.id == todo.id);
    if (index != -1) _mockData[index] = todo;
  }

  @override
  Future<void> deleteToDo(String id) async {
    _mockData.removeWhere((e) => e.id == id);
  }

  @override
  Future<TodoStatistics> getTodoStatistics() async {
    final completedCount = _mockData.where((e) => e.isDone).length;
    return TodoStatistics(total: _mockData.length, completed: completedCount);
  }
}
