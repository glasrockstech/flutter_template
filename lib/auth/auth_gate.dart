import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'view/sign_in_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final SupabaseClient _client;

  @override
  void initState() {
    super.initState();
    _client = Supabase.instance.client;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = _client.auth.currentSession;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (session == null) {
          return const SignInPage();
        }
        // Signed in — show your app's main entry.
        return const Placeholder(
          fallbackHeight: double.infinity,
          fallbackWidth: double.infinity,
          color: Colors.green,
          strokeWidth: 2,
        );
      },
    );
  }
}

