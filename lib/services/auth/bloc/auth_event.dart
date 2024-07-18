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

// Register.
class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String repeatPassword;

  const AuthEventRegister({
    required this.email,
    required this.password,
    required this.repeatPassword,
  });
}

// For the register button.
class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

// For the login button.
class AuthEventShouldLogin extends AuthEvent {
  const AuthEventShouldLogin();
}

// Homepage.
class AuthEventBlank extends AuthEvent {
  const AuthEventBlank();
}

// Send email verification.
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

// forgot pass.
class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}
