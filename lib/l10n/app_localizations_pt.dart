// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Love Movie (pt)';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get save => 'Salvar';

  @override
  String get saveInProgress => 'Salvando...';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get selectLanguage => 'Selecione um idioma.';

  @override
  String get chooseLanguage =>
      'Escolha o idioma utilizado em toda a aplicação.';

  @override
  String get languageUpdated => 'Idioma atualizado com sucesso.';

  @override
  String settingsLoadError(Object error) {
    return 'Não foi possível carregar as configurações.\n$error';
  }

  @override
  String languageUpdateError(Object error) {
    return 'Não foi possível atualizar o idioma.\n$error';
  }

  @override
  String get movieDetails => 'Detalhes do filme';

  @override
  String get year => 'Ano';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get genres => 'Gêneros';

  @override
  String movieLoadError(Object error) {
    return 'Não foi possível carregar o filme.\n$error';
  }

  @override
  String get movieNotFound => 'Filme não encontrado.';

  @override
  String get noGenres => 'Nenhum gênero informado.';

  @override
  String errorLoadingMovies(Object error) {
    return 'Não foi possível carregar os filmes.$error';
  }
}
