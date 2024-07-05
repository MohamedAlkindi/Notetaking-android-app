import 'package:Notetaking/Constants/routes.dart';
import 'package:flutter/material.dart';

// To use firebase class.
import 'package:firebase_core/firebase_core.dart';

// To use the 'create user' function.
import 'package:firebase_auth/firebase_auth.dart';

// Use this to initialize the firebase.
import '../Error_Handling/error_functions.dart';
import '../firebase_options.dart';

// Use stf to quickly create a stateful widget.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Creating 2 TextEditingController which takes whatever input inside a textfield.
  // Declaring a variable as late make sure that the variables will have values, but in the future.
  late final TextEditingController _email;
  late final TextEditingController _password;

  // But must create an initializer and a disposer manually.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: Center(
        child: Column(
          // makes all the column elements in the middle.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login.png',
              height: 180,
            ),
            Container(
              width: 450,
              margin: const EdgeInsets.fromLTRB(0, 25, 0, 15),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                controller: _email,
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
            SizedBox(
              width: 450,
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
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextButton(
                onPressed: () async {
                  await Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  );
                  final inputEmail = _email.text;
                  final inputPassword = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: inputEmail, password: inputPassword);

                    final loggedinUser = FirebaseAuth.instance.currentUser;

                    if (loggedinUser != null) {
                      if (loggedinUser.emailVerified) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          notesRoute,
                          (_) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                          emailVerifyRoute,
                        );
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    showErrorDialog(context, e.code);
                  } catch (e) {
                    // handle any other errors.
                    showErrorDialog(context, e.toString());
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(224, 199, 201, 228),
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Login',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered? Click here! 🖐🏼'),
            ),
          ],
        ),
      ),
    );
  }
}
