// ignore_for_file: use_build_context_synchronously

import 'package:Notetaking/Error_Handling/auth_exceptions.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/styles/style.dart';
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
        body: Container(
          decoration: AppStyle.backgroundImg,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/register.png',
                    height: 155,
                  ),
                  AppStyle.mainTextContainer('Hello There!', 0, 20, 0, 10),

                  // email container and textField.
                  AppStyle.emailContainer(
                    context: context,
                    focuseNode: _focusNode1,
                    email: _email,
                  ),

                  // Password textField.
                  AppStyle.passwordContainer(
                    context: context,
                    textFieldText: 'Enter Password',
                    isObsecureText: _isObsecure,
                    thisFocusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    passwordController: _password,
                    textInputActionValue: TextInputAction.next,
                    togglePasswordVisibility: () {
                      setState(
                        () {
                          _isObsecure = !_isObsecure;
                        },
                      );
                    },
                  ),

                  // Repeat Pass Container,
                  AppStyle.passwordContainer(
                    context: context,
                    textFieldText: 'Repeat Password',
                    isObsecureText: _isObsecure,
                    thisFocusNode: _focusNode2,
                    nextFocusNode: null,
                    passwordController: _repeatPassword,
                    textInputActionValue: TextInputAction.done,
                    togglePasswordVisibility: () {
                      setState(
                        () {
                          _isObsecure = !_isObsecure;
                        },
                      );
                    },
                  ),

                  // Register button.
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 15),
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
                        backgroundColor:
                            const Color.fromARGB(255, 107, 98, 187),
                        padding: const EdgeInsets.fromLTRB(90, 15, 90, 15),
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
                    child: AppStyle.secondButtonTextAndStyle(
                        'Already a user? Click here! 🖐🏼'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
