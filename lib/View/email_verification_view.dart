import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth/bloc/auth_bloc.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

// change later to use bloc.
AuthService s = AuthService.fireBase();

class _EmailVerifyViewState extends State<EmailVerifyView> {
  final user = s.getUserEmail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyle.backgroundImg,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Image.asset(
                  'assets/images/confirm.png',
                  height: 210,
                ),
              ),
              AppStyle.mainTextContainer(
                  'We have sent you an email verification to your email "$user!"',
                  0,
                  0,
                  0,
                  30),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 179, 135, 137),
                    padding: const EdgeInsets.fromLTRB(70, 15, 70, 15),
                  ),
                  child: AppStyle.secondButtonTextAndStyle(
                      'Click here to resend the email... 📨'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: AppStyle.secondButtonTextAndStyle('Go to login page.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
