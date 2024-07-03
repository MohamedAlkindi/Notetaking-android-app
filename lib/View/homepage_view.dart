// Main focus of this widget is to initialize the firebase once and for all views.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaking/View/login_view.dart';

import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // To create app bars and materials and such use Scaffold.
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),

      // snapshot is a state, u can get the result of the future using it.
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // If the ConnectionState returned 'Done'...
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;

            // // Creating a boolean value that'll make sure that a user is not null and is signed in.
            // final emailVerified = user?.emailVerified ?? false;

            // if (emailVerified) {
            //   // print('u r a verified user');
            // } else {
            //   // print('not verified');
            //   return const EmailVerifyView();
            // }
            // return const Text('Done');
            return const LoginView();
          // Otherwise show the text 'Loading'.
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
