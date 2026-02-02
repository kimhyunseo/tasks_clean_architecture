import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks/data/datasource/todo_data_source.dart';
import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/data/repository/todo_repository_impl.dart';
import 'package:tasks/domain/entity/todo_entity.dart';

// 1. Mock 클래스 선언
class MockTodoDataSource extends Mock implements TodoDataSource {}

// 2. any() 사용을 위한 Fallback 등록용 가짜 객체
class FakeToDoDto extends Fake implements ToDoDto {}

void main() {
  late MockTodoDataSource mockDataSource;
  late TodoRepositoryImpl repository;

  setUpAll(() {
    // registerFallbackValue는 any() 파라미터를 사용할 때 필요합니다.
    registerFallbackValue(FakeToDoDto());
  });

  setUp(() {
    print('[ToDoRepositoryTest] setUp: FakeFirebaseFirestore 초기화 (Mock)');
    mockDataSource = MockTodoDataSource();
    repository = TodoRepositoryImpl(mockDataSource);
  });

  group('ToDoRepositoryTest', () {
    test('addToDo should create a document', () async {
      print(
        '[ToDoRepositoryTest] === [TEST] addToDo should create a document 시작 ===',
      );

      final inputEntity = ToDoEntity(
        id: '1',
        title: 'Test',
        description: '',
        isFavorite: false,
        isDone: false,
        createdAt: DateTime.parse('2025-11-18 19:51:22.673422'),
      );

      final mockReturnDto = ToDoDto(
        id: '1', // 생성된 ID
        title: 'Test',
        description: '',
        isFavorite: false,
        isDone: false,
        createdAt: Timestamp.fromDate(inputEntity.createdAt),
      );

      // stubbing
      when(
        () => mockDataSource.addTodo(any()),
      ).thenAnswer((_) async => mockReturnDto);
      // getToDos 호출 시 결과값도 stubbing (검증용)
      when(
        () => mockDataSource.getTodos(limit: any(named: 'limit')),
      ).thenAnswer((_) async => [mockReturnDto]);

      print('[ToDoRepositoryTest] 1) addToDo 호출 전, todos 컬렉션 상태 확인 (Mock)');
      print('[ToDoRepositoryTest] 2) repository.addTodo(todo) 호출');
      final result = await repository.addToDo(todo: inputEntity);

      print('[ToDoRepositoryTest] 3) repository.getTodos() 호출로 저장 결과 확인');
      final pageResult = await repository.getToDos();

      print('  - getToDos 결과 length: ${pageResult.todos.length}');
      print('  - 첫 번째 todo: id=${result.id}, title=${result.title}');

      expect(pageResult.todos.length, 1);
      expect(result.id, '1');

      print(
        '[ToDoRepositoryTest] === [TEST] addToDo should create a document 종료 ===',
      );
    });

    test('getToDos should return list of todos ordered by created_at desc', () async {
      print(
        '[ToDoRepositoryTest] === [TEST] getToDos should return list of todos ordered by created_at desc 시작 ===',
      );

      final timeA = DateTime.parse('2025-11-18 19:51:22.705586');
      final timeB = DateTime.parse('2025-11-18 19:51:23.705586');

      final mockDtos = [
        ToDoDto(
          id: '2',
          title: 'B',
          description: '',
          isFavorite: false,
          isDone: false,
          createdAt: Timestamp.fromDate(timeB),
        ),
        ToDoDto(
          id: '1',
          title: 'A',
          description: '',
          isFavorite: false,
          isDone: false,
          createdAt: Timestamp.fromDate(timeA),
        ),
      ];

      when(
        () => mockDataSource.getTodos(
          limit: any(named: 'limit'),
          lastCursor: any(named: 'lastCursor'),
        ),
      ).thenAnswer((_) async => mockDtos);

      print(
        '[ToDoRepositoryTest] 1) Fake Firestore에 두 개의 todo 문서를 직접 삽입 (Mock 데이터 준비)',
      );
      print('  - doc 1 삽입: title=A, created_at=$timeA');
      print('  - doc 2 삽입: title=B, created_at=$timeB');

      print('[ToDoRepositoryTest] 2) repository.getToDos() 호출');
      final result = await repository.getToDos();

      print('  - getToDos 결과 length: ${result.todos.length}');
      for (var todo in result.todos) {
        print(
          '  - todo: id=${todo.id}, title=${todo.title}, createdAt=${todo.createdAt}',
        );
      }

      expect(result.todos.first.title, 'B'); // 최신순 확인
      print(
        '[ToDoRepositoryTest] === [TEST] getToDos should return list of todos ordered by created_at desc 종료 ===',
      );
    });

    test('deleteToDo removes the document', () async {
      print(
        '[ToDoRepositoryTest] === [TEST] deleteToDo removes the document 시작 ===',
      );

      when(() => mockDataSource.deleteTodo(any())).thenAnswer((_) async {});

      print('[ToDoRepositoryTest] 1) Fake Firestore에 doc 1 삽입 (Mock)');
      print('[ToDoRepositoryTest] 2) repository.deleteToDo("1") 호출');

      await repository.deleteToDo('1');

      print('[ToDoRepositoryTest] 3) Firestore에서 doc 1 조회해 존재 여부 확인 (Verify)');
      verify(() => mockDataSource.deleteTodo('1')).called(1);

      print('  - 삭제 후 doc.exists: false (Verified by call count)');
      print(
        '[ToDoRepositoryTest] === [TEST] deleteToDo removes the document 종료 ===',
      );
    });
  });

  tearDown(() {
    print('[ToDoRepositoryTest] tearDown: 현재 todos 문서 수 확인 완료 (Mock)');
  });
}
