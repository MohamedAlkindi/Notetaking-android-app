// Again, login page.
// Create an abstract class 'similar to interface' that returns the instance of that firebase user, and get the current user.

import 'package:Notetaking/services/auth/auth_user.dart';

abstract class AuthProvider {
  // Any auth user needs to optionaly return the current user.
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  // Register
  Future<AuthUser> createUser({
    required String inputEmail,
    required String inputPassword,
    required String repeatPassword,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}

// Add more auth providers, facebook, apple google... logins and register..
