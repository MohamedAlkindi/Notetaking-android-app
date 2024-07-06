// find a fix for the exceptions names for firebaseauthexceptions then add a class for each exception with similar implementation to this one.*Not worked on because it makes brute-force easier because they can identify the issue in their hack.
// Network error, and other FirebaseAuth exceptions.
class AuthExceptions implements Exception {}

// Generic exceptions *not of firebaseAuth
class GenericAuthException implements Exception {}

class PasswordsNotMatchException implements Exception {}

class UserNotLoggedInAuthExceptions implements Exception {}
