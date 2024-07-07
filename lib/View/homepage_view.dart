import 'package:Notetaking/View/notes_view.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/View/email_verification_view.dart';
import 'package:Notetaking/Constants/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Creates a widget or return one based on a condition in the 'Snapshot', takes 2 parameters 'future' which has the Future<> function, and 'builder' which will be used with the snapshot to return the widget.
    return FutureBuilder(
      future: AuthService.fireBase().initializer(),

      // snapshot is a state, u can get the result of the future using it.
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // If the ConnectionState returned 'Done'...
          case ConnectionState.done:
            final user = AuthService.fireBase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const EmailVerifyView();
              }
            } else {
              // If the user isn't signed in already then show the homepage.
              // To create app bars and materials and such use Scaffold.
              // Put ur mouse cursor over it to see what u can add to it.
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    // makes all the column elements in the middle.
                    mainAxisAlignment: MainAxisAlignment.center,

                    // 'Children' or 'child' is anything that u'll put inside the parent element.
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
                                // A navigator is a 'router' that routes the user to another view, using pushNamedAndRemoveUntil() function it navigates to another view and remove current view from the stack. 'cursor on function for more info...'
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute,
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Login',
                              ),
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
                              child: const Text(
                                'Register',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

          // Otherwise show a visual indicator 'when the connection is slow'.
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
