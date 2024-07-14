import 'package:Notetaking/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

// Loading state.
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

// Login state that has the user.
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

// Login errors that has the exception that caused the error.
class AuthStateLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateLoginFailure(this.exception);
}

// Email needs to be verified.
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// Logging out.
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

// Logging out errors.
class AuthStateLogOutFailures extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailures(this.exception);
}
