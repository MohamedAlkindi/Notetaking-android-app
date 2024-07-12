import 'package:Notetaking/services/auth/auth_exceptions.dart';
import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../Constants/routes.dart';
import '../Dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _repeatPassword;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  bool _isObsecure = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _repeatPassword = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
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
        child: SingleChildScrollView(
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
                  textInputAction: TextInputAction.next,
                  onSubmitted: (term) {
                    FocusScope.of(context).requestFocus(_focusNode1);
                  },
                ),
              ),

              // Password textField.
              Container(
                width: 450,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                // Password textbox.
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
                  focusNode: _focusNode1,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (term) {
                    FocusScope.of(context).requestFocus(_focusNode2);
                  },
                ),
              ),

              // Repeat pass textField.
              SizedBox(
                width: 450,
                child: TextField(
                  obscureText: _isObsecure,
                  enableSuggestions: false,
                  controller: _repeatPassword,
                  decoration: InputDecoration(
                    hintText: 'Repeat Password ',
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
                  focusNode: _focusNode2,
                  textInputAction: TextInputAction.done,
                ),
              ),

              // Register button.
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextButton(
                  onPressed: () async {
                    final inputEmail = _email.text;
                    final inputPassword = _password.text;
                    final inputRepeatPassword = _repeatPassword.text;

                    try {
                      if (inputPassword == inputRepeatPassword) {
                        await AuthService.fireBase().createUser(
                            inputEmail: inputEmail,
                            inputPassword: inputPassword,
                            repeatPassword: inputRepeatPassword);

                        AuthService.fireBase().sendEmailVerification();

                        Navigator.of(context).pushNamed(
                          emailVerifyRoute,
                        );
                      } else {
                        showErrorDialog(context, "Passwords don't match.");
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
      ),
    );
  }
}
