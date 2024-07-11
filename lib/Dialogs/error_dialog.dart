import 'package:Notetaking/Dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String content) {
  return showGenericDialog<void>(
    context: context,
    title: 'Error',
    content: content,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
