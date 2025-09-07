import 'package:flutter/material.dart';
import 'package:flutter_template/features/auth/view/auth_gate.dart';
import 'package:flutter_template/features/home/view/home_page.dart';
import 'package:flutter_template/features/splash/view/splash_page.dart';
import 'package:flutter_template/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
      routes: {
        '/auth': (_) => const AuthGate(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
