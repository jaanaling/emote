import 'dart:async';

import 'package:core_logic/core_logic.dart';
import 'package:core_amplitude/core_amplitude.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/core/dependency_injection.dart';
import 'src/feature/app/presentation/app_root.dart';

void main() async {
  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencyInjection();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await InitializationUtil.coreInit(
      domain: 'emotethis.com',
      amplitudeKey: '21ebf08b4c538f49c878ae3183d46327',
      appsflyerDevKey: 'BagJ29L5TZXSqMyJi8BF6W',
      appId: 'com.sparklinecreations.emotethis',
      iosAppId: '6739771343',
      initialRoute: '/home',
    );

    runApp(
      const AppRoot(),
    );
  }, (Object error, StackTrace stackTrace) {
    _handleAsyncError(error, stackTrace);
  });
}

void _handleFlutterError(FlutterErrorDetails details) {
  AmplitudeUtil.logFailure(
    details.exception is Exception ? Failure.exception : Failure.error,
    details.exception.toString(),
    details.stack,
  );
}

void _handleAsyncError(Object error, StackTrace stackTrace) {
  AmplitudeUtil.logFailure(
    error is Exception ? Failure.exception : Failure.error,
    error.toString(),
    stackTrace,
  );
}
