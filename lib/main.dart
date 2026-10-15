import 'package:flutter/material.dart';

import 'screens/movies_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:love_movie_app/l10n/app_localizations.dart';

void main() {
  // ponto te entrada da aplicação
  runApp(const LoveMovieApp());
}

class LoveMovieApp extends StatelessWidget {
  const LoveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Movie',
      debugShowCheckedModeBanner: false,
      home: const MoviesScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('en')],
    );
  }
}
