// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Love Movie (en)';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get save => 'Save';

  @override
  String get saveInProgress => 'Saving...';

  @override
  String get retry => 'Try again';

  @override
  String get selectLanguage => 'Please select a language.';

  @override
  String get chooseLanguage =>
      'Choose the language used throughout the application.';

  @override
  String get languageUpdated => 'Language updated successfully.';

  @override
  String settingsLoadError(Object error) {
    return 'Could not load settings.\n$error';
  }

  @override
  String languageUpdateError(Object error) {
    return 'Could not update the language.\n$error';
  }

  @override
  String get movieDetails => 'Movie Details';

  @override
  String get year => 'Year';

  @override
  String get originalLanguage => 'Original Language';

  @override
  String get genres => 'Genres';

  @override
  String movieLoadError(Object error) {
    return 'Could not load the movie.\n$error';
  }

  @override
  String get movieNotFound => 'Movie not found.';

  @override
  String get noGenres => 'No genres informed.';

  @override
  String errorLoadingMovies(Object error) {
    return 'Failed to load movies.$error';
  }
}
