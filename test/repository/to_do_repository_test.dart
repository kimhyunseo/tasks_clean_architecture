import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks/data/datasource/todo_data_source.dart';
import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/data/repository/todo_repository_impl.dart';
import 'package:tasks/domain/entity/todo_entity.dart';

class MockTodoDataSource extends Mock implements TodoDataSource {}

class FakeToDoDto extends Fake implements ToDoDto {}

void main() {
  late MockTodoDataSource mockDataSource;
  late TodoRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(FakeToDoDto()));

  setUp(() {
    mockDataSource = MockTodoDataSource();
    repository = TodoRepositoryImpl(mockDataSource);
  });

  group('TodoRepositoryImpl Test', () {
    test('addToDo 성공 테스트', () async {
      final todo = ToDoEntity(
        id: '1',
        title: '테스트',
        description: '',
        isFavorite: false,
        isDone: false,
        createdAt: DateTime.now(),
      );
      final mockDto = ToDoDto(
        id: 'new_id',
        title: '테스트',
        description: '',
        isFavorite: false,
        isDone: false,
        createdAt: Timestamp.now(),
      );

      when(
        () => mockDataSource.addTodo(any()),
      ).thenAnswer((_) async => mockDto);

      final result = await repository.addToDo(todo: todo);

      expect(result.id, 'new_id');
      verify(() => mockDataSource.addTodo(any())).called(1);
    });

    test('getToDos 정렬 확인 테스트', () async {
      final mockDtos = [
        ToDoDto(
          id: '2',
          title: '최신글',
          description: '',
          isFavorite: false,
          isDone: false,
          createdAt: Timestamp.now(),
        ),
        ToDoDto(
          id: '1',
          title: '옛날글',
          description: '',
          isFavorite: false,
          isDone: false,
          createdAt: Timestamp.now(),
        ),
      ];

      when(
        () => mockDataSource.getTodos(limit: any(named: 'limit')),
      ).thenAnswer((_) async => mockDtos);

      final result = await repository.getToDos();

      expect(result.todos.length, 2);
      expect(result.todos.first.title, '최신글');
    });

    test('deleteToDo 호출 확인', () async {
      when(() => mockDataSource.deleteTodo(any())).thenAnswer((_) async {});
      await repository.deleteToDo('1');

      verify(() => mockDataSource.deleteTodo('1')).called(1);
    });
  });
}
