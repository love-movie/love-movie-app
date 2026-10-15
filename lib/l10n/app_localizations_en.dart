// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Love Movie';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get save => 'Save';

  @override
  String get movieDetails => 'Movie Details';

  @override
  String get originalLanguage => 'Original Language';

  @override
  String get genres => 'Genres';

  @override
  String errorLoadingMovies(Object error) {
    return 'Failed to load movies.$error';
  }
}
