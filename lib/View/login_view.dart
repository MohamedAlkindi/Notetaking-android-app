import 'package:flutter/material.dart';
import 'package:Notetaking/Constants/routes.dart';
import '../Error_Handling/error_functions.dart';

// To use firebase class.
import 'package:firebase_core/firebase_core.dart';

// To use the 'create user' function.
import 'package:firebase_auth/firebase_auth.dart';

// Use this to initialize the firebase.
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login.png',
              height: 180,
            ),

            // Creating 2 'textboxes' one for email and the second for password, each in their own 'Container' to put some styling to them.
            // Email textfield.
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

            // 'SizedBox' is more suitable if u won't use properties of 'Container'. Otherwise use 'Container' as it has more properties to work with.
            // Password textfield.
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

            // Login button.
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextButton(
                onPressed: () async {
                  // Must initialize Firebase before using it, and must use 'async' in function declaration and 'await' when calling the initializeApp, because it's a Future<> function!
                  await Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  );

                  // As the user clicks on the button create 2 variables and get the text from the text boxes using the TextEditingController.
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
                        // Use pushNamed so u give the user an option to go back if he entered wrong details.
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

            // Register view button.
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
