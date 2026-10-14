import 'package:flutter/material.dart';

import 'movie_details_screen.dart';
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
      appBar: AppBar(title: const Text('Love Movie')),
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,

            itemBuilder: (context, index) {
              final movie = movies[index];

              return ListTile(
                title: Text(movie.title),

                subtitle: Text(movie.year.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
            // onTap is not a property of ListView.builder, it should be handled inside the ListTile
          );
        },
      ),
    );
  }
}
