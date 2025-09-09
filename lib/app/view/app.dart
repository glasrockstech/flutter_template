import 'package:flutter/material.dart';
import 'package:flutter_template/features/auth/view/auth_gate.dart';
import 'package:flutter_template/features/home/view/home_page.dart';
import 'package:flutter_template/features/splash/view/splash_page.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_template/theme/app_theme.dart';
import 'package:flutter_template/theme/theme_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/repositories/auth_repository.dart';
import 'package:flutter_template/repositories/user_repository.dart';
import 'package:flutter_template/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_template/app/router/app_router.dart';
import 'package:flutter_template/theme/theme_controller_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController()..load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return ThemeControllerProvider(
          notifier: _themeController,
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (_) => AuthRepository()),
              RepositoryProvider(create: (_) => UserRepository()),
            ],
            child: BlocProvider(
              create: (context) => AuthCubit(context.read<AuthRepository>()),
              child: MaterialApp(
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: _themeController.mode,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                initialRoute: AppRoutes.splash,
                routes: {
                  AppRoutes.splash: (_) => const SplashPage(),
                  AppRoutes.auth: (_) => const AuthGate(),
                  AppRoutes.home: (_) => const HomePage(),
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
