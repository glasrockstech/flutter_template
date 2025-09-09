import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_template/firebase_options.dart';

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

  // Initialize Firebase for Auth/other services.
  final isFlutterTest = Platform.environment['FLUTTER_TEST'] == 'true';
  if (!isFlutterTest) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
      log('Firebase initialized');
    } catch (e, st) {
      log('Firebase init error: $e', stackTrace: st);
    }
  }

  // Initialize Google Mobile Ads outside of tests.
  // Run non-blocking and handle errors inside the async task.
  if (!isFlutterTest) {
    unawaited(() async {
      try {
        final status = await MobileAds.instance
            .initialize()
            .timeout(const Duration(seconds: 4));
        log('MobileAds initialized with '
            '${status.adapterStatuses.length} adapters');
      } catch (e, st) {
        log('MobileAds init error: $e', stackTrace: st);
      }
    }());
  }

  runApp(await builder());
}
