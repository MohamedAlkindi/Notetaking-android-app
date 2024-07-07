// Create an abstract class 'similar to interface' that returns the instance of that firebase user, that gets that user, and have the operations that will be done to that user.

// Importing the auth_user.dart file because we abstracted the User that comes from the firebase into this class.
import 'package:Notetaking/services/auth/auth_user.dart';

abstract class AuthProvider {
  // Optional because it may or may not return a user.
  AuthUser? get currentUser;

  // Something will be done in the Future and returns <> an AuthUser.
  // In the original function that comes from firebase 'which will be used in the implementation' returning a user isnt optional , because if it can return a user it'll otherwise it'll throw an exception.
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
