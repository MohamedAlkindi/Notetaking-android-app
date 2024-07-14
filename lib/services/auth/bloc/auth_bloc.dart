import 'package:Notetaking/services/auth/auth_provider.dart';
import 'package:Notetaking/services/auth/bloc/auth_event.dart';
import 'package:Notetaking/services/auth/bloc/auth_state.dart';
import 'package:bloc/bloc.dart';

// Working with Bloc to separate the UI from the service and business logic.
// A Bloc takes an event emits a state in return.
// Check the AuthProvider class to refresh ur memory on operations in it and such..

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Get the auth provider because it has the logic, and give an inital state which is loading.
  // Bloc(State initialState) : super(initialState);
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initializer();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // login.
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    // logout.
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogOutFailures(e));
      }
    });
  }
}
