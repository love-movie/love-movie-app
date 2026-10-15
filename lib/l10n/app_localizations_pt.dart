// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Love Movie';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get save => 'Salvar';

  @override
  String get movieDetails => 'Detalhes do filme';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get genres => 'Gêneros';

  @override
  String errorLoadingMovies(Object error) {
    return 'Não foi possível carregar os filmes.$error';
  }
}
