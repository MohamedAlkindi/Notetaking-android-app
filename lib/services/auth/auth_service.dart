import 'package:Notetaking/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

// This class that'll be directly contacting the UI. so it implements the AuthProvider and giving it the values which will come from the UI, send it to AuthProvider and so on...
class AuthService implements AuthProvider {
  final AuthProvider provider;

  // Initialize that variable.
  const AuthService(this.provider);

  // factory constructor so we don't always provide an isntance for AuthProvider in order to use AuthService.
  factory AuthService.fireBase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String inputEmail,
    required String inputPassword,
    required String repeatPassword,
  }) =>
      provider.createUser(
        inputEmail: inputEmail,
        inputPassword: inputPassword,
        repeatPassword: repeatPassword,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initializer() => provider.initializer();
}
