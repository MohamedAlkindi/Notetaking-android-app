// login exceptions.
class AuthExceptionUserDisabled implements Exception {}

class AuthExceptionWrongPassword implements Exception {}

// Register exceptions.
class AuthExceptionEmailAlreadyInUse implements Exception {}

class AuthExceptionOperationNotAllowed implements Exception {}

class AuthExceptionWeakPassword implements Exception {}

// General exceptions.
class AuthExceptionUserNotFound implements Exception {}

class AuthExceptionInvalidEmail implements Exception {}

// Network error.
class NetworkExceptions implements Exception {}

// Generic exceptions *not of firebaseAuth
class GenericAuthException implements Exception {}

class PasswordsNotMatchException implements Exception {}

class UserNotLoggedInAuthExceptions implements Exception {}
