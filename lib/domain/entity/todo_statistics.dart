class TodoStatistics {
  final int total;
  final int completed;

  const TodoStatistics({required this.total, required this.completed});

  double get percent => total == 0 ? 0 : (completed / total) * 100;
}
