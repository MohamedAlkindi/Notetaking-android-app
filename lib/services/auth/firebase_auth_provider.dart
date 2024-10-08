import 'package:Notetaking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

// Implement the auth_user class.
import 'auth_user.dart';

// The abstract class.
import 'auth_provider.dart';

// for all exceptions.
import '../../Error_Handling/auth_exceptions.dart';

// Implement that abstract class with its getter and functions here.
class FirebaseAuthProvider implements AuthProvider {
  // Must initialize Firebase before using it, and must use 'async' in function declaration and 'await' when calling the initializeApp, because it's a Future<> function!
  @override
  Future<void> initializer() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    return (user != null) ? AuthUser.fromFirebase(user) : null;
  }

  @override
  Future<AuthUser> createUser({
    required String inputEmail,
    required String inputPassword,
    required String repeatPassword,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: inputEmail,
        password: inputPassword,
      );

      final user = currentUser;
      return user ?? (throw UserNotLoggedInAuthExceptions());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthExceptionInvalidEmail();
      } else if (e.code == 'email-already-in-use') {
        throw AuthExceptionEmailAlreadyInUse();
      } else if (e.code == 'weak-password') {
        throw AuthExceptionWeakPassword();
      } else if (e.code == 'network-request-failed') {
        throw NetworkExceptions;
      } else if (inputEmail == "" ||
          inputPassword == "" ||
          repeatPassword == "") {
        throw EmptyInputException();
      } else if (inputPassword != repeatPassword) {
        throw PasswordsNotMatchException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      return user ?? (throw UserNotLoggedInAuthExceptions());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthExceptionInvalidEmail();
      } else if (e.code == 'user-not-found') {
        throw AuthExceptionUserNotFound();
      } else if (e.code == 'wrong-password') {
        throw AuthExceptionWrongPassword();
      } else if (e.code == 'network-request-failed') {
        throw NetworkExceptions();
      } else if (email == "" || password == "") {
        throw EmptyInputException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> logOut() async {
    // currentUser not used!
    final user = currentUser;

    user != null
        ? await FirebaseAuth.instance.signOut()
        : throw UserNotLoggedInAuthExceptions();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = currentUser;

    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthExceptions();
    }
  }

  @override
  Future<void> sendPasswordReset({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthExceptionInvalidEmail();
      } else if (e.code == 'user-not-found') {
        throw AuthExceptionUserNotFound();
      }
    }
  }

  @override
  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }
}
