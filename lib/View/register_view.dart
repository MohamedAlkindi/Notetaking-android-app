import 'package:flutter/material.dart';
import '../Constants/routes.dart';
import '../Error_Handling/error_functions.dart';

// To use firebase class.
import 'package:firebase_core/firebase_core.dart';

// To use the 'create user' function.
import 'package:firebase_auth/firebase_auth.dart';

// Use this to initialize the firebase.
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _repeatPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _repeatPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/register.png',
              height: 140,
            ),
            Container(
              width: 450,
              margin: const EdgeInsets.fromLTRB(0, 25, 0, 15),

              // Email textfield.
              child: TextField(
                keyboardType: TextInputType
                    .emailAddress, // Adds the '@' symbol on keyboard.
                enableSuggestions: false,
                autocorrect: false,
                controller: _email,
                // Adding a placeholder..
                decoration: const InputDecoration(
                  hintText: 'Enter Email ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),

            // Password textField.
            Container(
              width: 450,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              // Password textbox.
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _password,
                decoration: const InputDecoration(
                  hintText: 'Enter Password ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),

            // Repeat pass textField.
            SizedBox(
              width: 450,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                controller: _repeatPassword,
                decoration: const InputDecoration(
                  hintText: 'Repeat Password ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),

            // Register button.
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: TextButton(
                onPressed: () async {
                  await Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  );

                  final inputEmail = _email.text;
                  final inputPassword = _password.text;
                  final inputRepeatPassword = _repeatPassword.text;

                  try {
                    if (inputPassword == inputRepeatPassword) {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: inputEmail,
                        password: inputPassword,
                      );
                      final user = FirebaseAuth.instance.currentUser;
                      // Send a verification email to the user.
                      await user?.sendEmailVerification();

                      Navigator.of(context).pushNamed(
                        emailVerifyRoute,
                      );
                    } else {
                      showErrorDialog(context, "Passwords don't match.");
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "network-request-failed") {
                      showErrorDialog(
                          context, "Please check your internet connection.");
                    } else {
                      showErrorDialog(
                          context, "Please check your email and/or password.");
                    }
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(224, 199, 201, 228),
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Register',
                ),
              ),
            ),

            // Login view button.
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text(
                'Already a user? Click here! 🖐🏼',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
