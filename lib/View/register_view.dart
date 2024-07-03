import 'package:flutter/material.dart';

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
    return Center(
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Center(
          child: Column(
            // makes all the column elements in the middle.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 450,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                // Creating 2 'textboxes' one for email and the second for password.
                // Username textbox.
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
              SizedBox(
                width: 450,
                // Password textbox.
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _password,
                  decoration: const InputDecoration(
                      hintText: 'Enter Password ',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextButton(
                  onPressed: () async {
                    // Must initialize Firebase before using it, and must use 'async' in function declaration and 'await' when calling the initializeApp function!
                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );

                    // As the user clicks on the button create 2 variables and get the text from the text boxes using the TextEditingController.
                    final inputEmail = _email.text;
                    final inputPassword = _password.text;

                    // Must put await as this is a Future function, again.
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: inputEmail, password: inputPassword);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        // print('Invalid Email.');
                      } else if (e.code == 'weak-password') {
                        // print('Weak password');
                      } else if (e.code == 'email-already-in-use') {
                        // print('Email already in use.');
                      }
                    }
                  },

                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(224, 199, 201, 228),
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                  ),
                  // 'child' is anything that u'll put inside the parent element, in this case TextButton is the parent and Text is the child.
                  child: const Text('Register'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  },
                  child: const Text('Already a user? Click here! 🖐🏼')),
            ],
          ),
        ),
      ),
    );
  }
}
