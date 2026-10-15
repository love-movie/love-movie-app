import 'package:flutter/material.dart';

import 'movie_details_screen.dart';
import 'settings_screen.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final MovieService _service = MovieService();

  late Future<List<Movie>> _futureMovies;

  @override
  void initState() {
    super.initState();

    _futureMovies = _service.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra de navegação superior (AppBar)
      appBar: AppBar(
        // título da AppBar
        title: const Text('Love Movie'),

        // ações da AppBar
        actions: [
          // botão de configurações
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings),

            // tratador do evento de press
            onPressed: () async {
              // navega para a tela de configurações
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsScreen();
                  },
                ),
              );

              debugPrint('[MoviesScreen] retorno=$updated');

              if (updated == true && mounted) {
                debugPrint('[MoviesScreen] recarregando filmes');
                setState(() {
                  _futureMovies = _service.getMovies();
                });
              }
            },
          ),
        ], // actions
      ),

      // corpo do Scaffold
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          // se estiver carregando os filmes, exibe um indicador de progresso
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // tratamento de erro ao carregar os filmes
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Não foi possível carregar os filmes.\n'
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _futureMovies = _service.getMovies();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return const Center(child: Text('Nenhum filme encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final futureMovies = _service.getMovies();

              setState(() {
                _futureMovies = futureMovies;
              });

              await futureMovies;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: movies.length,
              separatorBuilder: (context, index) {
                return const Divider(height: 1);
              },
              itemBuilder: (context, index) {
                final movie = movies[index];

                return ListTile(
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(movie.year.toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MovieDetailsScreen(movieId: movie.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
