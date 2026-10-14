import 'package:flutter/material.dart';

import 'screens/movies_screen.dart';

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
    );
  }
}
