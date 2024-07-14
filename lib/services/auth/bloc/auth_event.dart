import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

// First event it initializes the firebase..
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

// Loggin in
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

// Log out.
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
