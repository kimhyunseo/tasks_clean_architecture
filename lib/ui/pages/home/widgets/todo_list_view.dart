import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks/ui/pages/home/home_view_model.dart';
import 'package:tasks/ui/pages/home/widgets/todo_list_item.dart';

class TodoView extends ConsumerWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModel);
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 150),
      itemCount: homeState.todos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.go('/detail/${homeState.todos[index].id}');
          },

          child: ToDoWidget(todoId: homeState.todos[index].id),
        );
      },
    );
  }
}
