// Extending the functionality of BuildContext with our extension.
import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    // A modal route is something to pass arguemnts from.
    // Modal route of our build context.
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
