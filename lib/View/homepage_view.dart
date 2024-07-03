// Main focus of this widget is to initialize the firebase once and for all views.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaking/View/email_verification_view.dart';
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
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              if (user.emailVerified) {
                print('Email is verified');
              } else {
                return const EmailVerifyView();
              }
            } else {
              return const LoginView();
            }
            return const Text('Done');

          // Otherwise show the text 'Loading'.
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
