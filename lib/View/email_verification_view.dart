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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(204, 255, 255, 255),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 97, 98, 100).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(5, 5),
                )
              ],
            ),
            width: 630,
            height: 650,
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 55),
                    child: const Text(
                      'We have sent you an email verification!',
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventSendEmailVerification());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 149, 54, 228),
                        padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                      ),
                      child: const Text(
                        'Click here to resend the email.. 📨',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: const Text(
                        'Go to login page.',
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
