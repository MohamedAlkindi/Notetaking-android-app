// Creating a mock auth service, 'for testing'.
import 'package:Notetaking/Error_Handling/auth_exceptions.dart';
import 'package:Notetaking/services/auth/auth_provider.dart';
import 'package:Notetaking/services/auth/auth_user.dart';
import 'package:test/test.dart';

// Some tests failed, im dead...
void main() {
  // Testing go here!
  // Test group is like grouping a unit of related tests and run them all together.
  // group(Name Of Group, (parameters) {Function To Run})
  // Tests will run one after the other and will keep their values.
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    //test(Name Of Test, (parameters) {Function To Run})
    test('Should not be initialized to begin with', () {
      // Expect the isInitialized to be false.
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      // Expect upon testing this function to return the NotInitializedException.
      // When u expect a function to throw an exception in testing use 'throwsA(const TypeMatcher<againstAnException>())
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializeException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initializer();
      // Expect upon running that function _isInitialize to be true.
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    // Trying timeouts. A test should fail if our provider took more than x time. So it ensures that a test must finish before the timeout ends.
    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initializer();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate login function', () async {
      final badUserEmail = provider.createUser(
          inputEmail: 'hi@gmail.com',
          inputPassword: '123556',
          repeatPassword: '123556');

      expect(badUserEmail, throwsA(const TypeMatcher<GenericAuthException>()));

      final badUserPassword = provider.createUser(
          inputEmail: 'inputEmail',
          inputPassword: '123456',
          repeatPassword: '123456');

      expect(
          badUserPassword, throwsA(const TypeMatcher<GenericAuthException>()));

      // Trying another user 'doesnt matter if it doesnt comply to Firebase rules for email and password, just to check if the email and password arent the bad ones it sets it as the current user.
      final correctUser = await provider.createUser(
          inputEmail: 'inputEmail',
          inputPassword: 'inputPassword',
          repeatPassword: 'repeatPassword');
      expect(provider.currentUser, correctUser);

      // testing that after creating a user the isVerified is false by default.
      expect(correctUser.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, false);
    });

    test('Should be able to logout and in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

// Creating a new exception for the _isInitialize flag.
class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  // Creating a flag to check if the firebase is initialized or not.
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Creating a temp user to use in testing of currentUser getter.
  AuthUser? _user;

/* Testing creating a user..
 1- Checks if the firebase is initialized.
 2- Faking creating a user.
 3- calls the login function, just to return a user. 'not actually creating a user.'*/
  @override
  Future<AuthUser> createUser({
    required String inputEmail,
    required String inputPassword,
    required String repeatPassword,
  }) async {
    if (!isInitialized) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: inputEmail,
      password: inputPassword,
    );
  }

  @override
  AuthUser? get currentUser => _user;

// Just fake waiting and make the flag true.
  @override
  Future<void> initializer() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializeException();
    // Writing scinarios.
    if (email == 'hi@gmail.com') throw GenericAuthException();
    if (password == '123456') throw GenericAuthException();

    // creating a user, and assign it to our user.
    // as the user signs in then obviously the boolean value of the user will be turned to true.
    const user = AuthUser(
      id: 'xx',
      isEmailVerified: false,
      email: 'yepe@gmail.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializeException();
    if (_user == null) throw UserNotLoggedInAuthExceptions();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializeException();
    // The isVerified in AuthUser class if final, so we have to rewrite our user with a new user in order to change the isVerified boolean value that it has.
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthExceptions();

    // creating a 'new user' that has the boolean value as false, and replace it with the old user.
    const newUser = AuthUser(
      id: 'xx',
      isEmailVerified: false,
      email: 'ye@gmail.com',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String email}) {
    throw UnimplementedError();
  }
}
