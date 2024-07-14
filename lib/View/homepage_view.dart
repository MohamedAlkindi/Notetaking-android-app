import 'package:Notetaking/View/login_view.dart';
import 'package:Notetaking/View/notes/notes_view.dart';
import 'package:Notetaking/View/register_view.dart';
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerifyView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const CircularProgressIndicator();
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
