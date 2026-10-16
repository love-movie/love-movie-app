import 'package:flutter/material.dart';
import 'package:love_movie_app/l10n/app_localizations.dart';

import 'models/user_preferences.dart';
import 'screens/movies_screen.dart';
import 'services/user_preferences_service.dart';

void main() {
  // ponto te entrada da aplicação
  runApp(const LoveMovieApp());
}

class LoveMovieApp extends StatefulWidget {
  const LoveMovieApp({super.key});

  static LoveMovieAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<LoveMovieAppState>();
  }

  @override
  State<LoveMovieApp> createState() {
    return LoveMovieAppState();
  }
}

class LoveMovieAppState extends State<LoveMovieApp> {
  Locale _locale = const Locale('pt', 'BR');

  // indicativo de que as preferências do usuário estão sendo carregadas.
  bool _isLoadingPreferences = true;

  // serviço de preferências do usuário, para buscar as configurações do usuário
  // para carregar a aplicação considerando as preferências do usuário
  // (por exemplo, idioma).
  final UserPreferencesService _userPreferencesService =
      UserPreferencesService();

  @override
  void initState() {
    super.initState();
    _loadInitialPreferences();
  }

  Future<void> _loadInitialPreferences() async {
    debugPrint('[LoveMovieApp] Carregando preferências iniciais...');

    try {
      // recupera no back as preferências do usuário
      final UserPreferences preferences = await _userPreferencesService
          .getPreferences();
      debugPrint(
        '[LoveMovieApp] Idioma carregado do back, nos user preferences: ${preferences.languageCode}',
      );

      // converte o idioma do usuário em um objeto Locale correspondente.
      final Locale locale = localeFromLanguageCode(preferences.languageCode);

      if (!mounted) {
        return;
      }

      // configura o locale da aplicação com base nas preferências do usuário.
      setState(() {
        _locale = locale;
        _isLoadingPreferences = false;
      });
    } // fim do try
    catch (error, stackTrace) {
      // em caso de erro, coloca o erro no console
      debugPrint('[LoveMovieApp] Erro ao carregar preferências: $error');
      debugPrint(stackTrace.toString());

      if (!mounted) {
        return;
      }

      // em caso de erro, define o locale padrão para pt-BR
      setState(() {
        _locale = const Locale('pt', 'BR');
        _isLoadingPreferences = false;
      });
    } // fim do catch
  } // fim do método _loadInitialPreferences

  void setLocale(Locale locale) {
    debugPrint(
      '[LoveMovieApp] Alterando locale atual ${_locale.languageCode}-${_locale.countryCode} '
      'para: ${locale.languageCode}-${locale.countryCode}',
    );

    if (_locale == locale) {
      return;
    }

    setState(() {
      _locale = locale;
    });
  }

  void setLocaleFromLanguageCode(String languageCode) {
    final Locale locale = localeFromLanguageCode(languageCode);
    setLocale(locale);
  }

  // este método converte um código de idioma em um objeto Locale correspondente.
  Locale localeFromLanguageCode(String languageCode) {
    Locale result;

    debugPrint(
      '[LoveMovieApp] Convertendo languageCode para Locale: $languageCode',
    );

    switch (languageCode) {
      case 'pt-BR':
        result = const Locale('pt', 'BR');
        break;

      case 'en-US':
        result = const Locale('en', 'US');
        break;

      default:
        result = const Locale('pt', 'BR');
        debugPrint(
          '[LoveMovieApp] Idioma $languageCode não reconhecido. fallback locale: $result',
        );
        break;
    }
    debugPrint('[LoveMovieApp] Locale convertido: $result');
    return result;
  } // fim do método localeFromLanguageCode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // a tela home será mostrada apenas quando as preferências iniciais
      // forem carregadas.
      home: _isLoadingPreferences
          ? const _AppLoadingScreen()
          : const MoviesScreen(),

      // este callback é usado para gerar o título da aplicação com base no
      // locale atual. O ! significa que estamos garantindo que o resultado
      // de AppLocalizations.of(context) não será nulo.
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}

// esta classe representa a tela de carga de preferências iniciais do aplicativo.
class _AppLoadingScreen extends StatelessWidget {
  const _AppLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando preferências...'),
          ],
        ),
      ),
    );
  }
}
