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
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/forgotPass.png',
                  height: 180,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: const Text(
                    'Enter your email to reset your password!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  margin: const EdgeInsets.fromLTRB(10, 25, 10, 15),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _controller,
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
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 149, 54, 228),
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                  ),
                  child: const Text(
                    'Send password reset. 📨',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Back to login page. 🔙'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
