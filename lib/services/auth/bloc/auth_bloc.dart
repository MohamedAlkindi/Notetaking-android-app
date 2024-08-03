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
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        emit(
          // naming is trash so try to figure it out each time...
          // when the user presses on register button it triggeres an event to register.
          // first thing it does is show loading screen, and then get the text fields value.
          // lastly create the user and send email verification or show an error...
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait while we are signing you up...'),
        );
        final email = event.email;
        final password = event.password;
        final repeatPassword = event.repeatPassword;
        try {
          await provider.createUser(
            inputEmail: email,
            inputPassword: password,
            repeatPassword: repeatPassword,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(
            AuthStateRegistering(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );

// login.
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait while we are logging you in...'),
        );
        final email = event.email;
        final password = event.password;

        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              // stop the loading screen.
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              // then throw user needs verification state.
              const AuthStateNeedsVerification(
                isLoading: false,
              ),
            );
          } else {
            // if the user is verified, stop the loading screen.
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              // and log the user in.
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            // on any exception stop the loading screen and throw the exception.
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initializer();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateBlank());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        }
      },
    );

    // logout.
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );

    // forgot password.
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: false,
          ),
        );
        final email = event.email;
        if (email == null || email == "") {
          return; /* just to show the FP screen */
        }
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: true,
          ),
        );

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(email: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(
          AuthStateForgotPassword(
            exception: exception,
            hasSentEmail: didSendEmail,
            isLoading: false,
          ),
        );
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(
          const AuthStateRegistering(
            exception: null,
            isLoading: false,
          ),
        );
      },
    );

    on<AuthEventShouldLogin>(
      (event, emit) {
        emit(
          const AuthStateLoggingIn(),
        );
      },
    );
  }
}
