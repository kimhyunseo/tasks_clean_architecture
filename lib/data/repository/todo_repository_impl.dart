// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/domain/entity/todo_page_result.dart';
import 'package:tasks/domain/repository/todo_repository.dart';
import '../../domain/entity/todo_entity.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirebaseFirestore firestore;
  TodoRepositoryImpl(this.firestore);

  /// 할 일 목록 보기
  @override
  Future<TodoPageResult> getToDos({int limit = 15, Object? lastCursor}) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection('todos')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastCursor != null) {
        query = query.startAfterDocument(
          lastCursor as DocumentSnapshot<Map<String, dynamic>>,
        );
      }

      final result = await query.get();

      final todos = result.docs.map((doc) {
        final dto = ToDoDto.fromFirestore(doc);
        return ToDoEntity(
          id: dto.id,
          title: dto.title,
          description: dto.description,
          isFavorite: dto.isFavorite,
          isDone: dto.isDone,
          createdAt: dto.createdAt.toDate(),
          updatedAt: dto.updatedAt?.toDate(),
        );
      }).toList();

      return TodoPageResult(
        todos: todos,
        lastCursor: result.docs.isNotEmpty
            ? result.docs.last as DocumentSnapshot<Map<String, dynamic>>
            : null,
      );
    } catch (e) {
      print('할 일 목록을 불러오는 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 할 일 추가
  @override
  Future<ToDoEntity> addToDo({required ToDoEntity todo}) async {
    try {
      final docRef = firestore.collection('todos').doc();

      final dto = ToDoDto(
        id: docRef.id,
        title: todo.title,
        description: todo.description,
        isFavorite: todo.isFavorite,
        isDone: todo.isDone,
        createdAt: Timestamp.fromDate(todo.createdAt),
        updatedAt: null,
      );

      await docRef.set(dto.toFirestore());
      return todo.copyWith(id: docRef.id);
    } catch (e) {
      print('할 일 추가 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 할 일 수정
  @override
  Future<void> updateToDo({required ToDoEntity todo}) async {
    try {
      final dto = ToDoDto(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isFavorite: todo.isFavorite,
        isDone: todo.isDone,
        createdAt: Timestamp.fromDate(todo.createdAt),
        updatedAt: Timestamp.now(),
      );

      await firestore
          .collection('todos')
          .doc(todo.id)
          .update(dto.toFirestore());
    } catch (e) {
      print('할 일 수정 중 오류 발생: $e');
      rethrow;
    }
  }

  /// 할 일 삭제
  @override
  Future<void> deleteToDo(String id) async {
    try {
      await firestore.collection('todos').doc(id).delete();
    } catch (e) {
      print('할 일 삭제 중 오류 발생: $e');
      rethrow;
    }
  }
}
