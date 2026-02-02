// lib/domain/entities/todo_statistics.dart

class TodoStatistics {
  final int total;
  final int completed;

  TodoStatistics({required this.total, required this.completed});

  // 0으로 나누기 방지가 포함된 퍼센트 계산 로직
  double get percent => total == 0 ? 0 : (completed / total) * 100;
}
