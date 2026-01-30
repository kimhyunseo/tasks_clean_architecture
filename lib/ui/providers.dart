import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import 'package:tasks/domain/repository/todo_repository_impl.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(FirebaseFirestore.instance);
});
