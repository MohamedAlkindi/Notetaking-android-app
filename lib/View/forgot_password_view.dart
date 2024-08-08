// ignore_for_file: use_build_context_synchronously

import 'package:Notetaking/Dialogs/error_dialog.dart';
import 'package:Notetaking/Dialogs/password_reset_email_sent_dialog.dart';
import 'package:Notetaking/services/auth/bloc/auth_bloc.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/auth/bloc/auth_state.dart';
import 'package:Notetaking/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
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
          decoration: AppStyle.backgroundImg,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/forgotPass.png',
                    height: 150,
                  ),
                  AppStyle.mainTextContainer(
                      'Enter your email to reset your password!', 0, 20, 0, 10),
                  AppStyle.emailContainer(
                    context: context,
                    email: _email,
                    focuseNode: null,
                  ),
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: TextButton(
                      onPressed: () {
                        String email = _email.text;
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
                    child: AppStyle.secondButtonTextAndStyle(
                        'Back to login page. 🔙'),
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
