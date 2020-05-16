import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hisabkitab/main.dart';

class AppLocalizations {
  final Locale locale;

  Map<String, String> _localizedMap;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// helper method
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// loads the json
  Future<bool> load() async {
    String languageCode = prefs.getString('languageCode');
    if (languageCode == null)
      languageCode = locale.languageCode;

    String jsonString = await rootBundle.loadString('lang/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedMap = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  /// gets the string to be displayed
  /// [key] - gets the value for this key
  String translate(String key) {
    return _localizedMap[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// checks if the locale is supported or not
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  /// loads the locale, json in our case
  /// returns Future of instance of [AppLocalizations]
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
