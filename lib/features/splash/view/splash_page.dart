import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Small delay to show the splash, then route based on env.
    Future<void>.delayed(const Duration(milliseconds: 600), _goNext);
  }

  void _goNext() {
    final hasSupabase = dotenv.isInitialized &&
        (dotenv.env['SUPABASE_URL']?.isNotEmpty ?? false) &&
        (dotenv.env['SUPABASE_ANON_KEY']?.isNotEmpty ?? false);
    final next = hasSupabase ? '/auth' : '/home';
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.all_inbox_rounded, size: 96, color: color),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
