import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_template/repositories/auth_repository.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('AuthRepository error mapping', () {
    late _MockFirebaseAuth mockAuth;
    late AuthRepository repo;

    setUp(() {
      mockAuth = _MockFirebaseAuth();
      repo = AuthRepository(firebaseAuth: mockAuth);
    });

    test('maps wrong-password to AuthFailure.wrongPassword', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        () => repo.signIn(email: 'a@b.com', password: 'x'),
        throwsA(equals(AuthFailure.wrongPassword)),
      );
    });

    test('maps user-not-found to AuthFailure.userNotFound', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => repo.signIn(email: 'missing@example.com', password: 'x'),
        throwsA(equals(AuthFailure.userNotFound)),
      );
    });

    test('maps network-request-failed to AuthFailure.network', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );

      expect(
        () => repo.signIn(email: 'a@b.com', password: 'x'),
        throwsA(equals(AuthFailure.network)),
      );
    });
  });
}
