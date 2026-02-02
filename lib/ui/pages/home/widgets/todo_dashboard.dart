import 'package:flutter/material.dart';
import 'package:tasks/domain/entity/todo_statistics.dart';

class TodoDashboard extends StatelessWidget {
  final TodoStatistics statistics;
  final bool isHorizontal;

  const TodoDashboard({
    super.key,
    required this.statistics,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor;
    final double p = statistics.percent;

    if (p >= 70) {
      accentColor = const Color(0xFF1864AB);
    } else if (p >= 35) {
      accentColor = const Color(0xFF339AF0);
    } else {
      accentColor = const Color(0xFF74C0FC);
    }

    return Container(
      width: isHorizontal ? 200 : double.infinity,
      margin: isHorizontal
          ? const EdgeInsets.fromLTRB(12, 12, 12, 80)
          : const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isHorizontal
          ? _buildCompactCircleLayout(accentColor)
          : _buildBarLayout(accentColor),
    );
  }

  // 세로모드
  Widget _buildBarLayout(Color accentColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.whatshot_rounded, color: accentColor, size: 24),
            const SizedBox(width: 8),
            const Text(
              "오늘의 성취",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "${statistics.completed} / ${statistics.total}",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            Text(
              "${statistics.percent.toInt()}%",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: statistics.percent / 100,
          backgroundColor: Colors.grey[100],
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  // 가로모드
  Widget _buildCompactCircleLayout(Color accentColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.whatshot_rounded, color: accentColor, size: 20),
            const SizedBox(width: 6),
            const Text(
              "성취도",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: statistics.percent / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey[100],
                color: accentColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              "${statistics.percent.toInt()}%",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "${statistics.completed}/${statistics.total} 완료",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
