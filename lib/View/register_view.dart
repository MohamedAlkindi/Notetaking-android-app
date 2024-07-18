// ignore_for_file: use_build_context_synchronously

import 'package:Notetaking/Error_Handling/auth_exceptions.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Dialogs/error_dialog.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is PasswordsNotMatchException) {
            await showErrorDialog(
              context,
              'Passwords dont match',
            );
          } else if (state.exception is AuthExceptionInvalidEmail) {
            await showErrorDialog(
              context,
              'Please enter a valid email.',
            );
          } else if (state.exception is AuthExceptionEmailAlreadyInUse) {
            await showErrorDialog(
              context,
              'This email is already in use.',
            );
          } else if (state.exception is AuthExceptionWeakPassword) {
            await showErrorDialog(
              context,
              'Please type a stronger password.',
            );
          } else if (state.exception is EmptyInputException) {
            await showErrorDialog(
              context,
              'Please fill all the input fields.',
            );
          } else if (state.exception is NetworkExceptions) {
            await showErrorDialog(
              context,
              'Please check your internet connection',
            );
          } else {
            await showErrorDialog(
              context,
              'Something went wrong!',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/register.png',
                  height: 180,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: const Text(
                    'Hello there!',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  margin: const EdgeInsets.fromLTRB(10, 25, 10, 15),

                  // Email textfield.
                  child: TextField(
                    autofocus: true,
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
                      suffixIcon: Icon(
                        Icons.email,
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
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
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextButton(
                    onPressed: () async {
                      final inputEmail = _email.text;
                      final inputPassword = _password.text;
                      final inputRepeatPassword = _repeatPassword.text;
                      context.read<AuthBloc>().add(AuthEventRegister(
                            email: inputEmail,
                            password: inputPassword,
                            repeatPassword: inputRepeatPassword,
                          ));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 149, 54, 228),
                      padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Login view button.
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text(
                    'Already a user? Click here! 🖐🏼',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
