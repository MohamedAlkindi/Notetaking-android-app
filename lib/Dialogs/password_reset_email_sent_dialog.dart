import 'package:Notetaking/Dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        'Follow the link we sent you to your email to reset your password!',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
