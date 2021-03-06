import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hisabkitab/app.dart' as App;
import 'package:hisabkitab/src/provider/store.dart';
import 'package:hisabkitab/utils/app_localizations.dart';
import 'package:hisabkitab/utils/const.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global instance of [SharedPreferences]
SharedPreferences prefs;

/// Instance of [SentryClient]
final SentryClient sentry = SentryClient(
    dsn: Constants.sentryDsn,
    environmentAttributes: Event(environment: Constants.sentryDsn));

void main() async {
  /// Ensures that widgets binding is done before running the app
  WidgetsFlutterBinding.ensureInitialized();

  /// Gets the instance of SharedPreferences
  prefs = await SharedPreferences.getInstance();

  /// Catches and reports flutter error in sentry
  runZonedGuarded<Future<void>>(() async => runApp(MyApp()),
      (error, stackTrace) {
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
          /// Custom delegate, handles locale related things
          AppLocalizations.delegate,

          /// Following are the default delegates
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'), // English
          Locale('hi', 'IN'), // Hindi
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          /// Returns the device locale, if supported otherwise first supported language
          for (var currentLocale in supportedLocales) {
            if (currentLocale.languageCode == locale.languageCode &&
                currentLocale.countryCode == locale.countryCode)
              return currentLocale;
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
