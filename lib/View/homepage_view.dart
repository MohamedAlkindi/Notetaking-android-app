import 'package:Notetaking/View/forgot_password_view.dart';
import 'package:Notetaking/View/login_view.dart';
import 'package:Notetaking/View/notes/notes_view.dart';
import 'package:Notetaking/View/register_view.dart';
import 'package:Notetaking/helpers/loading/loading_screen.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/View/email_verification_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // use .add() to communicate with bloc.
    // Read AuthBloc from the context as u injected it inside the context in the main.dart file.
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoginPage) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerifyView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            // To make the column scrollable.
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon.png',
                    height: 180,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: const Text(
                      'Welcome!\n\nYour notes are safe and sound with us 😁',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 50, 20),
                        child: TextButton(
                          onPressed: () async {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldLogin());
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 149, 54, 228),
                            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: TextButton(
                          onPressed: () async {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 149, 54, 228),
                            padding: const EdgeInsets.fromLTRB(43, 15, 43, 15),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
    );

    // Creates a widget or return one based on a condition in the 'Snapshot', takes 2 parameters 'future' which has the Future<> function, and 'builder' which will be used with the snapshot to return the widget.
    // return FutureBuilder(
    //   future: AuthService.fireBase().initializer(),

    //   // snapshot is a state, u can get the result of the future using it.
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       // If the ConnectionState returned 'Done'...
    //       case ConnectionState.done:
    //         final user = AuthService.fireBase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             return const NotesView();
    //           } else {
    //             return const EmailVerifyView();
    //           }
    //         } else {
    //           // If the user isn't signed in already then show the homepage.
    //           // To create app bars and materials and such use Scaffold.
    //           // Put ur mouse cursor over it to see what u can add to it.
    //
    //             ),
    //           );
    //         }

    //       // Otherwise show a visual indicator 'when the connection is slow'.
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );
  }
}
