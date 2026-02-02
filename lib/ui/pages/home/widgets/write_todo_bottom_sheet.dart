import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/core/utils/throttler.dart';
import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/ui/pages/home/home_view_model.dart';

class WriteTodo extends ConsumerStatefulWidget {
  const WriteTodo({super.key});
  @override
  ConsumerState<WriteTodo> createState() => _PlusTodoState();
}

class _PlusTodoState extends ConsumerState<WriteTodo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  bool isFavorite = false;
  bool isDescription = false;
  bool isTitleEmpty = true;

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      setState(() {
        isTitleEmpty = titleController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void saveToDo() {
    final value = titleController.text;
    final descriptionValue = descriptionController.text;

    if (isTitleEmpty) {
      titleFocusNode.requestFocus();
      return;
    }

    Throttler.run(
      'save_todo',
      duration: Duration(milliseconds: 1000),
      action: () async {
        final viewModel = ref.read(homeViewModel.notifier);
        await viewModel.onEvent(
          HomeAddTodo(
            ToDoEntity(
              id: '',
              title: value,
              description: descriptionValue,
              isFavorite: isFavorite,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ),
        );

        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            focusNode: titleFocusNode,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              saveToDo();
            },
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              hintText: "새 할 일",
              hintStyle: TextStyle(fontSize: 14),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 16),
          ),

          if (isDescription)
            TextField(
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                hintText: "세부정보 추가",
                hintStyle: TextStyle(fontSize: 12),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 14),
            ),

          Row(
            children: [
              if (isDescription == false)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isDescription = true;
                      descriptionFocusNode.requestFocus();
                    });
                  },
                  icon: Icon(Icons.short_text_rounded, size: 24),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: isFavorite
                    ? Icon(Icons.star_rounded, size: 24)
                    : Icon(Icons.star_border_rounded, size: 24),
              ),
              Spacer(),
              TextButton(
                onPressed: isTitleEmpty ? null : saveToDo,
                child: Text("저장"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
