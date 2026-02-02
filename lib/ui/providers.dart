import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/data/datasource/todo_data_source.dart';
import 'package:tasks/data/datasource/todo_data_source_impl.dart';
import 'package:tasks/data/repository/todo_repository_impl.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:tasks/domain/usecase/get_todo_statistics_usecase.dart';
// import 'package:tasks/data/repository/todo_repository_mock.dart';

// 데이터 소스 프로바이더
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  return TodoDataSourceImpl(FirebaseFirestore.instance);
});

// 리포지토리 프로바이더
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  // Mock 데이터 사용 시:
  // return TodoRepositoryMock();

  // 실제 DB 사용 시:
  final dataSource = ref.watch(todoDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});

final getTodoStatisticsUseCaseProvider = Provider<GetTodoStatisticsUseCase>((
  ref,
) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodoStatisticsUseCase(repository);
});
