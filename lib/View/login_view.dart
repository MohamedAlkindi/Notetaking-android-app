import 'package:Notetaking/services/auth/bloc/auth_bloc.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/auth/bloc/auth_state.dart';
import 'package:Notetaking/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  late FocusNode _focusNode1;

  bool _isObsecure = true;
  // But must create an initializer and a disposer manually.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _focusNode1 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNode1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is AuthExceptionInvalidEmail ||
              state.exception is AuthExceptionUserNotFound) {
            await showErrorDialog(
              context,
              'You have entered a wrong email.',
            );
          } else if (state.exception is EmptyInputException) {
            await showErrorDialog(
              context,
              'Please fill all the input fields.',
            );
          } else if (state.exception is AuthExceptionWrongPassword) {
            await showErrorDialog(
              context,
              'Wrong credentials.',
            );
          } else if (state.exception is NetworkExceptions) {
            await showErrorDialog(
              context,
              'Please check your internet connection',
            );
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: AppStyle.backgroundImg,
          child: Center(
            // To make the column scrollable.
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    height: 140,
                  ),
                  AppStyle.mainTextContainer('Welcome Back!', 0, 20, 0, 10),

                  // email container and textField.
                  AppStyle.emailContainer(
                    context: context,
                    focuseNode: _focusNode1,
                    email: _email,
                  ),

                  // 'SizedBox' is more suitable if u won't use properties of 'Container'. Otherwise use 'Container' as it has more properties to work with.

                  // Password textfield.
                  AppStyle.passwordContainer(
                    context: context,
                    textFieldText: 'Enter Password',
                    isObsecureText: _isObsecure,
                    thisFocusNode: _focusNode1,
                    nextFocusNode: null,
                    passwordController: _password,
                    textInputActionValue: TextInputAction.done,
                    togglePasswordVisibility: () {
                      setState(
                        () {
                          _isObsecure = !_isObsecure;
                        },
                      );
                    },
                  ),

                  // Login button.
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 25),
                    child: TextButton(
                      onPressed: () async {
                        // As the user clicks on the button create 2 variables and get the text from the text boxes using the TextEditingController.
                        final inputEmail = _email.text;
                        final inputPassword = _password.text;

                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                inputEmail,
                                inputPassword,
                              ),
                            );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 202, 144, 145),
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
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventShouldRegister());
                      },
                      child: AppStyle.secondButtonTextAndStyle(
                          'Not registered? Click here! 🖐🏼')),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 73, 70, 70),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
