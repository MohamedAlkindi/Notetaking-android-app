// Note: if any "Configuration not found" error is there, go to the console website, authorization, and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in".
import 'package:Notetaking/services/auth/bloc/auth_bloc.dart';
import 'package:Notetaking/services/auth/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/View/homepage_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Constants/routes.dart';
import 'View/notes/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const MaterialApp(
    // To remove the debug banner that's shown on the rightmost of the app when running.
    debugShowCheckedModeBanner: false,
  );

  runApp(
    MaterialApp(
      title: 'Notetaking App',

      theme: ThemeData(
        // Main theme of the app.
        primarySwatch: Colors.red,
      ),

      // Choose and run the homepage.
      // Using AuthBloc functionality in the main.dart initialize it and inject the bloc into the context of every view.
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),

      // Create routes to swich from login to register... and vise versa..
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNote(),
      },
    ),
  );
}
