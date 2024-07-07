import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

// Trying to get out all the code that's not UI focused from the login view.
// It means that this class and it's subclasses internals won't be changed upon initialization.
@immutable

// Abstract the firebase User with a new class that takes the firebase User.
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

// factory constructor to return a current instance of the logged in user.
// take the user from the firebase, and only get the emailVerified value, then put that value in your class.
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
