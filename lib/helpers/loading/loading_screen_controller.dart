import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreenContent = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreenContent updateContent;

  const LoadingScreenController({
    required this.close,
    required this.updateContent,
  });

  
}
