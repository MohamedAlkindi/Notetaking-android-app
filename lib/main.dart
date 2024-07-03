// Note: if any "Configuration not found" error is there, go to the console website, authorization, and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in".

import 'package:flutter/material.dart';
import 'package:notetaking/View/login_view.dart';
import 'package:notetaking/View/register_view.dart';
import 'View/homepage_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    },
  ));
}
