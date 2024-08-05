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
    // Adding 'required' to create a named paramater to make it more understandable.
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

// factory constructor to return a current instance of the logged in user.
// take the user from the firebase, and get the emailVerified value, and email then put those values in your class.
// When pressing . after the AuthUser u r declaring a new function. We give this function the user and it initalize the value of the boolean variable with the emailVerified state of the sent user.
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
  Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
