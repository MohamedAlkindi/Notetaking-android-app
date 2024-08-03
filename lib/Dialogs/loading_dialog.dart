// Allow the caller to dismiss a dialog
import 'package:flutter/material.dart';

// typedef can sometimes refer to just an alias of a function, and sometimes it can be more complicated and means other things...
typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  return () => Navigator.of(context).pop();
}
