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

// Email needs to be verified.
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// Logging out.
class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

// Logging out errors.
class AuthStateLogOutFailures extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailures(this.exception);
}
