import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:Notetaking/Constants/routes.dart';
import '../Dialogs/error_dialog.dart';
import '../Error_Handling/auth_exceptions.dart';

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

  late FocusNode _myFocusNote;

  bool _isObsecure = true;
  // But must create an initializer and a disposer manually.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _myFocusNote = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _myFocusNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // To make the column scrollable.
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login.png',
                height: 180,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Georgia',
                  ),
                ),
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
                    suffixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (term) {
                    FocusScope.of(context).requestFocus(_myFocusNote);
                  },
                ),
              ),

              // 'SizedBox' is more suitable if u won't use properties of 'Container'. Otherwise use 'Container' as it has more properties to work with.
              // Password textfield.
              SizedBox(
                width: 450,
                child: TextField(
                  obscureText: _isObsecure,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: 'Enter Password ',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _isObsecure = !_isObsecure);
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                      ),
                    ),
                  ),
                  focusNode: _myFocusNote,
                  textInputAction: TextInputAction.done,
                ),
              ),

              // Login button.
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextButton(
                  onPressed: () async {
                    // As the user clicks on the button create 2 variables and get the text from the text boxes using the TextEditingController.
                    final inputEmail = _email.text;
                    final inputPassword = _password.text;

                    try {
                      await AuthService.fireBase().logIn(
                        email: inputEmail,
                        password: inputPassword,
                      );

                      final loggedinUser = AuthService.fireBase().currentUser;

                      if (loggedinUser != null) {
                        if (loggedinUser.isEmailVerified) {
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
                    } on NetworkExceptions {
                      showErrorDialog(
                          context, "Please check your internet connection.");
                    } on AuthExceptions {
                      showErrorDialog(
                          context, "Please check your input details.");
                    } on GenericAuthException {
                      showErrorDialog(context, "An error has happened!");
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 149, 54, 228),
                    padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
      ),
    );
  }
}
