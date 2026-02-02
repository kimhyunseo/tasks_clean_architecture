import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/ui/pages/home/home_view_model.dart';
import 'package:tasks/ui/pages/home/widgets/empty_todo.dart';
import 'package:tasks/ui/pages/home/widgets/write_todo_bottom_sheet.dart';
import 'package:tasks/ui/pages/home/widgets/todo_list_view.dart';
import 'package:tasks/ui/theme_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModel);
    final isLight =
        ref.watch(themeViewModelProvider).themeMode == ThemeMode.light;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Hyunseo\'s Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeViewModelProvider.notifier).toggleTheme();
            },

            icon: Icon(isLight ? Icons.nightlight : Icons.sunny),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => WriteTodo(),
          );
        },
        child: Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(homeViewModel.notifier).onEvent(HomeRefreshRequested());

          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
        },

        child: homeState.todos.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [EmptyTodo()],
              )
            : TodoView(),
      ),
    );
  }
}
