import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_template/features/home/view/home_page.dart';

import 'package:flutter_template/features/auth/view/sign_in_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  SupabaseClient? _client;
  bool _supabaseAvailable = true;

  @override
  void initState() {
    super.initState();
    try {
      _client = Supabase.instance.client;
    } catch (_) {
      _supabaseAvailable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_supabaseAvailable || _client == null) {
      // No Supabase configured — skip auth and go straight to Home.
      return const HomePage();
    }
    return StreamBuilder<AuthState>(
      stream: _client!.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = _client!.auth.currentSession;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (session == null) {
          return const SignInPage();
        }
        return const HomePage();
      },
    );
  }
}
