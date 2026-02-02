import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';
import 'package:tasks/domain/repository/todo_repository.dart';

class TodoRepositoryMock implements TodoRepository {
  final List<ToDoEntity> _mockData = [
    ToDoEntity(
      id: '1',
      title: 'Flutter 공부하기',
      description: 'Clean Architecture랑 Riverpod 깊게 파보기',
      isDone: false,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ToDoEntity(
      id: '2',
      title: '운동하기',
      description: '헬스장 가서 하체 조지기',
      isDone: true,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ToDoEntity(
      id: '3',
      title: '책 읽기',
      description: '개발 서적 읽기',
      isDone: false,
      isFavorite: false,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<TodoPageResult> getToDos({int limit = 15, Object? lastCursor}) async {
    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    // 페이지네이션 로직 시뮬레이션
    // 실제로는 lastCursor를 기반으로 잘라야 하지만, Mock에서는 간단히 전체 반환하거나
    // 인덱스 기반으로 흉내낼 수 있음. 여기서는 간단히 구현.
    final startIndex = 0; // lastCursor 로직은 복잡하므로 생략하거나 필요시 구현
    final endIndex = (startIndex + limit).clamp(0, _mockData.length);

    // lastCursor가 있는 경우, 해당 아이템 다음부터 가져와야 함 (간략 구현)
    List<ToDoEntity> results = [];
    if (lastCursor != null && lastCursor is ToDoEntity) {
      final index = _mockData.indexWhere((e) => e.id == lastCursor.id);
      if (index != -1 && index + 1 < _mockData.length) {
        results = _mockData.sublist(
          index + 1,
          (index + 1 + limit).clamp(0, _mockData.length),
        );
      }
    } else {
      results = _mockData.sublist(0, limit.clamp(0, _mockData.length));
    }

    return TodoPageResult(
      todos: results,
      hasMore: results.isNotEmpty && _mockData.last.id != results.last.id,
      lastCursor: results.isNotEmpty ? results.last : null,
    );
  }

  @override
  Future<ToDoEntity> addToDo({required ToDoEntity todo}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTodo = todo.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _mockData.insert(0, newTodo); // 최신순
    return newTodo;
  }

  @override
  Future<void> updateToDo({required ToDoEntity todo}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockData.indexWhere((e) => e.id == todo.id);
    if (index != -1) {
      _mockData[index] = todo;
    }
  }

  @override
  Future<void> deleteToDo(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockData.removeWhere((e) => e.id == id);
  }
}
