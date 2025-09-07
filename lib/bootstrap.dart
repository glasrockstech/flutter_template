import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  String envFileName = '.env',
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Load env for the current flavor.
  try {
    await dotenv.load(fileName: envFileName);
    log('Loaded env: $envFileName');
  } catch (e) {
    log('Env load failed for $envFileName: $e');
  }

  // Initialize Supabase if credentials are present.
  final supabaseUrl = dotenv.isInitialized ? dotenv.env['SUPABASE_URL'] : null;
  final supabaseAnonKey =
      dotenv.isInitialized ? dotenv.env['SUPABASE_ANON_KEY'] : null;
  final isFlutterTest = Platform.environment['FLUTTER_TEST'] == 'true';
  if (!isFlutterTest && supabaseUrl != null && supabaseAnonKey != null) {
    try {
      // Avoid blocking first frame indefinitely if network hangs.
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      ).timeout(const Duration(seconds: 6));
      log('Supabase initialized');
    } catch (e, st) {
      log('Supabase init error: $e', stackTrace: st);
    }
  } else {
    log('Supabase skipped (missing creds or test environment)');
  }

  // Initialize Google Mobile Ads outside of tests.
  if (!isFlutterTest) {
    try {
      // Non-blocking; initialization can complete in background.
      unawaited(
        MobileAds.instance
            .initialize()
            .timeout(const Duration(seconds: 4))
            .catchError((e, st) => log('MobileAds init error: $e', stackTrace: st)),
      );
      log('MobileAds initialized');
    } catch (e, st) {
      log('MobileAds init error: $e', stackTrace: st);
    }
  }

  runApp(await builder());
}
