import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthState.unknown()) {
    _sub = _repo.userChanges.listen((user) {
      if (user == null) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(AuthState.authenticated(email: user.email));
      }
    });
  }

  final AuthRepository _repo;
  late final StreamSubscription _sub;

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await _repo.signIn(email: email, password: password);
    } on AuthFailure catch (f) {
      emit(state.copyWith(loading: false, error: f));
    } catch (_) {
      emit(state.copyWith(loading: false, error: AuthFailure.unknown));
    } finally {
      if (state.loading) emit(state.copyWith(loading: false));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await _repo.signUp(email: email, password: password);
    } on AuthFailure catch (f) {
      emit(state.copyWith(loading: false, error: f));
    } catch (_) {
      emit(state.copyWith(loading: false, error: AuthFailure.unknown));
    } finally {
      if (state.loading) emit(state.copyWith(loading: false));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _repo.sendPasswordResetEmail(email);
    } on AuthFailure catch (f) {
      emit(state.copyWith(error: f));
    } catch (_) {
      emit(state.copyWith(error: AuthFailure.unknown));
    }
  }

  Future<void> signOut() => _repo.signOut();

  void clearError() => emit(state.copyWith(error: null));

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
