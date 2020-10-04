library firebase_auth_repository;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/index.dart';

// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs
class LoginWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the signin with google process if a failure occurs
class LoginWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs
class LogoutFailure implements Exception {}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}

/// {@template authenticate_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository(
      {firebase_auth.FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) =>
        firebaseUser == null ? User.empty : firebaseUser.toUser);
  }

  /// Creates a new user with the provider [email] and [password]
  ///
  /// Throws a [SignUpFailure] if an exception occurs
  Future<void> signup(
      {@required String email, @required String password}) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow
  ///
  /// Throws a [LoginWithGoogleFailure] if an exception occurs
  Future<void> loginInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LoginWithGoogleFailure();
    }
  }

  /// Signs in with provided [email] and [password].
  ///
  /// Throws a [LoginWithEmailAndPasswordFailure]  if an exception occurs.
  Future<void> loginWithEmailAndPassword(
      {@required String email, @required String password}) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception {
      throw LoginWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogoutFailure] if an exception occurs
  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } on Exception {
      throw LogoutFailure();
    }
  }
}
