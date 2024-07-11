// this will how a different values for the dialog based on what u give it.

import 'package:flutter/material.dart';

// Every button show have a text to it, and every button should return a value upon pressing on it, that's why it's generic., using map to link between a String key 'text' and a generic value.
// Put it in a function so it returns that value. 'syntax is super weird!'.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

// Sometimes u press outside the dialog so it returns null instead of true or false. That's why it's an optional data type.
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  // These are the option that will be displayed to the user.
  final options = optionBuilder();

  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    }),
  );
}
