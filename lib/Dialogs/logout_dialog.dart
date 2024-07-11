import 'package:Notetaking/Dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      "No": false,
      "Yes": true,
    },
    // Either take the returned value or by default it's false, it's when the user press outside the dialog.
  ).then((value) => value ?? false);
}
