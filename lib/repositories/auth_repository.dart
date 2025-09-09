import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthUser {
  const AuthUser({required this.uid, this.email});
  final String uid;
  final String? email;
}

class AuthRepository {
  AuthRepository({fb.FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  Stream<AuthUser?> get userChanges => _auth.userChanges().map(_mapUser);

  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw AuthFailure.unknown;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw AuthFailure.unknown;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw AuthFailure.unknown;
    }
  }

  Future<void> signOut() => _auth.signOut();

  AuthUser? _mapUser(fb.User? u) =>
      u == null ? null : AuthUser(uid: u.uid, email: u.email);
}

/// Domain-level failures for auth operations.
enum AuthFailure {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  tooManyRequests,
  weakPassword,
  emailAlreadyInUse,
  requiresRecentLogin,
  network,
  unknown,
}

AuthFailure _mapAuthException(fb.FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return AuthFailure.invalidEmail;
    case 'user-disabled':
      return AuthFailure.userDisabled;
    case 'user-not-found':
      return AuthFailure.userNotFound;
    case 'wrong-password':
      return AuthFailure.wrongPassword;
    case 'too-many-requests':
      return AuthFailure.tooManyRequests;
    case 'weak-password':
      return AuthFailure.weakPassword;
    case 'email-already-in-use':
      return AuthFailure.emailAlreadyInUse;
    case 'requires-recent-login':
      return AuthFailure.requiresRecentLogin;
    case 'network-request-failed':
      return AuthFailure.network;
    default:
      return AuthFailure.unknown;
  }
}

extension AuthRepositoryMutations on AuthRepository {
  Future<void> changeEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw AuthFailure.unknown;
    try {
      // Firebase Auth v6: prefer verifyBeforeUpdateEmail which sends a
      // verification email to the new address before applying the change.
      await user.verifyBeforeUpdateEmail(newEmail);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw AuthFailure.unknown;
    }
  }
}
