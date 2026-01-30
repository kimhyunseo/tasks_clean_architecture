import 'package:flutter/cupertino.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = "취소",
  String confirmText = "확인",
  bool isDestructive = false,
  required VoidCallback onConfirm,
}) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
