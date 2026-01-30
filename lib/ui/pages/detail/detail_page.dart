// // ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks/domain/entity/todo_entity.dart';
import 'package:tasks/ui/pages/detail/detail_view_model.dart';
import 'package:tasks/utils/dialog_utils.dart';
import 'package:tasks/utils/snackbar_utils.dart';

class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailViewModelProvider(id));
    final currentTodo = detailState.todo;

    if (detailState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentTodo == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("할 일을 찾을 수 없습니다.")),
      );
    }
    return _TodoDetailContent(
      todo: currentTodo,
      viewModel: ref.read(detailViewModelProvider(id).notifier),
    );
  }
}

class _TodoDetailContent extends StatefulWidget {
  const _TodoDetailContent({required this.todo, required this.viewModel});

  final ToDoEntity todo;
  final DetailViewModel viewModel;

  @override
  State<_TodoDetailContent> createState() => _TodoDetailContentState();
}

class _TodoDetailContentState extends State<_TodoDetailContent> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(
      text: widget.todo.description ?? '',
    );

    titleController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool get isChanged {
    return titleController.text != widget.todo.title ||
        descriptionController.text != (widget.todo.description ?? '');
  }

  void _editTodo() {
    showConfirmationDialog(
      context: context,
      title: "저장 확인",
      content: "변경된 내용을 저장하시겠습니까?",
      confirmText: "저장",
      isDestructive: false,
      onConfirm: () async {
        widget.viewModel.onEvent(
          DetailEditTodo(
            widget.todo.copyWith(
              title: titleController.text,
              description: descriptionController.text,
            ),
          ),
        );

        if (!mounted) return;
        SnackbarUtils.showSnackBr(context, "할 일이 수정되었습니다");
      },
    );
  }

  void _deleteTodo() {
    showConfirmationDialog(
      context: context,
      title: "삭제 확인",
      content: "정말 삭제하시겠습니까?",
      confirmText: "삭제",
      isDestructive: true,
      onConfirm: () async {
        if (mounted) {
          Navigator.pop(context); // 다이얼로그 닫기
        }

        // 삭제 요청
        await widget.viewModel.onEvent(DetailDeleteTodo());

        if (!mounted) return;

        // 삭제 후 뒤로 가기 및 스낵바
        Navigator.pop(context); // 상세 페이지 닫기
        SnackbarUtils.showSnackBr(context, "할 일이 삭제되었습니다");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Hero(
          tag: widget.todo.id,
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.todo.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.viewModel.onEvent(DetailToggleFavorite());
            },
            icon: widget.todo.isFavorite
                ? const Icon(Icons.star_rounded, size: 28)
                : const Icon(Icons.star_border_rounded, size: 28),
          ),
          IconButton(
            onPressed: _deleteTodo,
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      floatingActionButton: isChanged
          ? FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: _editTodo,
              icon: const Icon(Icons.save),
              label: const Text("저장하기"),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _editTodo(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none,
                hintText: '제목을 입력하세요',
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.short_text_rounded, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    minLines: 1,
                    maxLines: 8,
                    textInputAction: TextInputAction.newline,
                    // onSubmitted는 multiline에서 동작하지 않을 수 있음
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      hintText: '설명을 입력하세요',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
