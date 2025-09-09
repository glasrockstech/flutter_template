part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.email,
    this.loading = false,
    this.error,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);
  const AuthState.authenticated({String? email})
      : this._(status: AuthStatus.authenticated, email: email);
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final String? email;
  final bool loading;
  final AuthFailure? error;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    bool? loading,
    AuthFailure? error,
  }) =>
      AuthState._(
        status: status ?? this.status,
        email: email ?? this.email,
        loading: loading ?? this.loading,
        error: error,
      );

  @override
  List<Object?> get props => <Object?>[status, email, loading, error];
}
