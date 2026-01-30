import 'package:tasks/domain/entity/todo_entity.dart';

abstract class TodoRepository {
  Future<List<ToDoEntity>> getToDos();
  Future<ToDoEntity> addToDo({required ToDoEntity todo});
  Future<void> updateToDo({required ToDoEntity todo});
  Future<void> deleteToDo(String id);
}
