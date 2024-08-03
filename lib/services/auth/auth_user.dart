// Trying to get out all the code that's not UI focused from the login view.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// It means that this class and it's subclasses internals won't be changed upon initialization.
@immutable

// Abstract the firebase User with a new class that takes the firebase User.
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
  Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
