import 'package:Notetaking/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

// unintialized state, just to call the initialization method.
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
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
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

// for the registration if its all good or something bad happened.
class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}
