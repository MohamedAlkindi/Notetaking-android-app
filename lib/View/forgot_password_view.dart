// ignore_for_file: use_build_context_synchronously

import 'package:Notetaking/Dialogs/error_dialog.dart';
import 'package:Notetaking/Dialogs/password_reset_email_sent_dialog.dart';
import 'package:Notetaking/services/auth/bloc/auth_bloc.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We could not process your request, try checking your entered email.');
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/forgotPass.png',
                    height: 150,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: const Text(
                      'Enter your email to reset your password!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Georgia',
                        color: Color.fromARGB(255, 73, 70, 70),
                      ),
                    ),
                  ),
                  Container(
                    width: 450,
                    margin: const EdgeInsets.fromLTRB(10, 25, 10, 15),
                    child: TextField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 73, 70, 70),
                        fontSize: 18,
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Email ',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 100, 99, 99),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 131, 58, 66),
                              width: 0.7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 131, 58, 66),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 73, 70, 70),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: TextButton(
                      onPressed: () {
                        String email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email: email));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 187, 141, 143),
                        padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                      ),
                      child: const Text(
                        'Send password reset. 📨',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text(
                      'Back to login page. 🔙',
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 70, 70),
                      ),
                    ),
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
