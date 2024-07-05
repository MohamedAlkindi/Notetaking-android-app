import 'package:Notetaking/View/notes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/View/email_verification_view.dart';

import '../Constants/routes.dart';
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
                return const NotesView();
              } else {
                return const EmailVerifyView();
              }
            } else {
              // If the user isn't signed in already then show the homepage.
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/notes.jpeg',
                        height: 250,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 80, 0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(40, 15, 40, 15),
                                padding:
                                    const EdgeInsets.fromLTRB(28, 15, 28, 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute,
                                  (route) => false,
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(40, 15, 40, 15),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  registerRoute,
                                  (route) => false,
                                );
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

          // Otherwise show the text 'Loading'.
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
