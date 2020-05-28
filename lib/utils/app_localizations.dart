import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hisabkitab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class for handling localizations
class AppLocalizations {
  /// Locale of the device
  final Locale locale;

  /// Language's map of words
  Map<String, String> _localizedMap;

  AppLocalizations(this.locale);

  /// Instance of the custom delegate
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// Helper method
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Loads the json
  Future<bool> load() async {
    if (prefs == null)
      prefs = await SharedPreferences.getInstance();

    /// Get the language code from the device
    String languageCode = prefs.getString('languageCode');

    /// Haven't set the preferred language yet, set the language from the device
    if (languageCode == null || languageCode.isEmpty || languageCode == "null")
      languageCode = locale.languageCode;

    /// Get the json file using the languageCode, Ex: en.json for English
    String jsonString = await rootBundle.loadString('lang/$languageCode.json');

    /// Creates and sets the map of the words
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedMap = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  /// Gets the string to be displayed
  String translate(String key) {
    return _localizedMap[key];
  }
}

/// Custom localizations delegate class
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// Is the language supported?
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  /// Loads the locale, json in our case
  ///
  /// Returns the localizations to be used
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// Should the delegate be reloaded?
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
