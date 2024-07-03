// Note: if any "Configuration not found" error is there, go to the console website, authorization, and enable the configuration for ur security option "email and password, facebook, apple, twitter.... sign in".

import 'package:flutter/material.dart';
import 'View/Login_View/login_view.dart';
import 'View/Register_View/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Notetaking App',

    theme: ThemeData(
      // Main theme of the app.
      primarySwatch: Colors.blue,
    ),

    // Choose and run the homepage.
    home: const RegisterView(),
  ));
}
