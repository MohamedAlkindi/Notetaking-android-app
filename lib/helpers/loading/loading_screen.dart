// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:Notetaking/helpers/loading/loading_screen_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  // show loading screen with stuff... 'text, columns....'
  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);

    // get sizes that the overlay can have.
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                // at most 80% of available width
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // allow user to scroll to see rest of content.
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // display the overlay.
    state.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, updateContent: ((text) {
      _text.add(text);
      return true;
    }));
  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.updateContent(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }
}
