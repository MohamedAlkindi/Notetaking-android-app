import 'package:Notetaking/services/auth/auth_service.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth/bloc/auth_bloc.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Email Verification',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/confirm.png',
              height: 210,
            ),
            const Text(
              'We have sent you an email verification....',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(224, 199, 201, 228),
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Click here to resend the email.. 📨',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(224, 199, 201, 228),
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  'Go to login page.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
