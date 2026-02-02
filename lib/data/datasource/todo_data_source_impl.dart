import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/data/datasource/todo_data_source.dart';
import 'package:tasks/data/dto/todo_firestore_dto.dart';
import 'package:tasks/data/dto/todo_statistics_dto.dart';

class TodoDataSourceImpl implements TodoDataSource {
  TodoDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<ToDoDto>> getTodos({int limit = 15, Object? lastCursor}) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastCursor != null && lastCursor is ToDoDto) {
      query = query.startAfter([lastCursor.createdAt]);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ToDoDto.fromFirestore(doc)).toList();
  }

  @override
  Future<ToDoDto> addTodo(ToDoDto todo) async {
    final docRef = _firestore.collection('todos').doc();
    await docRef.set(todo.toFirestore());
    return todo.copyWith(id: docRef.id);
  }

  @override
  Future<void> updateTodo(ToDoDto todo) {
    final docRef = _firestore.collection('todos').doc(todo.id);
    return docRef.update(todo.toFirestore());
  }

  @override
  Future<void> deleteTodo(String id) {
    final docRef = _firestore.collection('todos').doc(id);
    return docRef.delete();
  }

  @override
  Future<TodoStatisticsDto> getTodoStatistics() async {
    final todosCollection = _firestore.collection('todos');

    // 두 개의 집계 쿼리를 병렬로 실행
    final totalCountQuery = todosCollection.count();
    final completedCountQuery = todosCollection
        .where('isDone', isEqualTo: true)
        .count();

    final results = await Future.wait([
      totalCountQuery.get(),
      completedCountQuery.get(),
    ]);

    final totalCount = results[0].count ?? 0;
    final completedCount = results[1].count ?? 0;

    return TodoStatisticsDto(total: totalCount, completed: completedCount);
  }
}
