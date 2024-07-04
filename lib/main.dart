// Note: if any "Configuration not found" error is there, go to the console website, authorization, and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in".

import 'package:Notetaking/View/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/View/login_view.dart';
import 'package:Notetaking/View/register_view.dart';
import 'View/homepage_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const MaterialApp(
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

    // Create routes to swich from login to register and vise versa..
    routes: {
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView(),
      "/notes/": (context) => const NotesView(),
    },
  ));
}
