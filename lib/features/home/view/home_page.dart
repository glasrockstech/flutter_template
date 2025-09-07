import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    try {
      email = Supabase.instance.client.auth.currentUser?.email;
    } catch (_) {
      // Supabase not initialized; keep email null.
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              try {
                await Supabase.instance.client.auth.signOut();
              } catch (e, st) {
                log('Sign out skipped or failed: $e', stackTrace: st);
                // If Supabase is not initialized, just ignore.
              }
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/auth', (r) => false);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!'),
            if (email != null) ...[
              const SizedBox(height: 8),
              Text(email, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

