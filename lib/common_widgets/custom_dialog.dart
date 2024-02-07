import 'package:flutter/material.dart';

import '../navigation_key.dart';

class CustomDialog {
  static showCustomDialogWithoutContext({
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x01000000),
    required Widget child,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  static showCustomDialog({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x01000000),
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: builder,
    );
  }
}
