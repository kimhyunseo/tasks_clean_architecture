import 'package:flutter/material.dart';

class SnackbarUtils {
  SnackbarUtils._();

  /// 단순 메시지 스낵바
  static void showSnackBr(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }

  /// 액션 버튼이 있는 스낵바
  static void showActionSnackBar({
    required BuildContext context,
    required String text,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 5),
      // 액션이 있을 때
      persist: false,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(label: actionLabel, onPressed: onAction),
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(snackBar);
  }
}
