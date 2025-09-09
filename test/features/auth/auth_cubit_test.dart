import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_template/repositories/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthCubit', () {
    late _MockAuthRepository repo;

    setUp(() {
      repo = _MockAuthRepository();
      // Avoid initial emissions from auth stream in tests.
      when(() => repo.userChanges).thenAnswer((_) => const Stream.empty());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [loading true, error wrongPassword] when signIn fails',
      build: () {
        when(() => repo.signIn(email: any(named: 'email'), password: any(named: 'password')))
            .thenThrow(AuthFailure.wrongPassword);
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.signIn('a@b.com', 'bad'),
      expect: () => [
        isA<AuthState>().having((s) => s.loading, 'loading', true),
        isA<AuthState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.error, 'error', AuthFailure.wrongPassword),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading true, loading false] on successful signIn',
      build: () {
        when(() => repo.signIn(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async {});
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.signIn('a@b.com', 'good'),
      expect: () => [
        isA<AuthState>().having((s) => s.loading, 'loading', true),
        isA<AuthState>().having((s) => s.loading, 'loading', false),
      ],
    );
  });
}

