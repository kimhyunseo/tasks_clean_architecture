import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/data/datasource/todo_data_source.dart'; // 인터페이스
import 'package:tasks/data/datasource/todo_data_source_impl.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:tasks/data/repository/todo_repository_impl.dart';

// 1. 데이터 소스 프로바이더
final todoDataSourceProvider = Provider<TodoDataSource>((ref) {
  return TodoDataSourceImpl(FirebaseFirestore.instance);
});

// 2. 리포지토리 프로바이더
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dataSource = ref.watch(todoDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});
