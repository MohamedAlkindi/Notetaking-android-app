import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Your email is not verified'),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;

              await user?.sendEmailVerification();
            },
            child: const Text('Click here to verify your email.. 👋🏼')),
      ],
    );
  }
}
