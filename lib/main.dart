import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hisabkitab/app.dart' as App;
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
final SentryClient sentry = SentryClient(dsn: Constants.sentryDsn, environmentAttributes: Event(environment: Constants.sentryDsn));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runZoned(() => runApp(MyApp()), onError: (error, stackTrace) {
    FlutterError.onError = (details, {bool forceReport = false}) {
      try {
        sentry.captureException(exception: error, stackTrace: stackTrace);
        print('something went wrong, check sentry');
      } catch (e) {
        print('error: $e');
      } finally {
        FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
      }
    };
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: ThemeData(
          primarySwatch: Constants.primarySwatch,
        ),
        home: App.App(),
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('hi'), // Hindi
        ],
      ),
    );
  }
}
