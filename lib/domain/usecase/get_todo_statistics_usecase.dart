import 'package:tasks/domain/entity/todo_statistics.dart';
import 'package:tasks/domain/repository/todo_repository.dart';

class GetTodoStatisticsUseCase {
  final TodoRepository repository;

  GetTodoStatisticsUseCase(this.repository);

  Future<TodoStatistics> execute() async {
    return await repository.getTodoStatistics();
  }
}
