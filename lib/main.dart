// Note: if any "Configuration not found" error is there, go to the console website, authorization, and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in".

import 'package:flutter/material.dart';
import 'package:Notetaking/View/notes/notes_view.dart';
import 'package:Notetaking/View/login_view.dart';
import 'package:Notetaking/View/register_view.dart';
import 'package:Notetaking/View/email_verification_view.dart';
import 'package:Notetaking/View/homepage_view.dart';
import 'Constants/routes.dart';
import 'View/notes/new_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const MaterialApp(
    // To remove the debug banner that's shown on the rightmost of the app when running.
    debugShowCheckedModeBanner: false,
  );

  runApp(MaterialApp(
    title: 'Notetaking App',

    theme: ThemeData(
      // Main theme of the app.
      primarySwatch: Colors.deepPurple,
    ),

    // Choose and run the homepage.
    home: const HomePage(),

    // Create routes to swich from login to register... and vise versa..
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      emailVerifyRoute: (context) => const EmailVerifyView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}
