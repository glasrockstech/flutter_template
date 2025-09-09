import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserRepository {
  UserRepository({fb.FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  String? get email => _auth.currentUser?.email;

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
    }
  }
}

