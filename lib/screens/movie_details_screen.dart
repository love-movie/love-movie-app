import 'package:flutter/material.dart';
import 'package:love_movie_app/l10n/app_localizations.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() {
    return _MovieDetailsScreenState();
  }
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();

  late Future<Movie> _futureMovie;

  @override
  void initState() {
    super.initState();

    _futureMovie = _movieService.getMovieById(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.movieDetails)),
      body: FutureBuilder<Movie>(
        future: _futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.movieLoadError(snapshot.error ?? ''),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: Text(l10n.movieNotFound));
          }

          final movie = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                _InformationRow(label: l10n.year, value: movie.year.toString()),

                const SizedBox(height: 12),

                _InformationRow(
                  label: l10n.originalLanguage,
                  value: movie.originalLanguageCode,
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.genres,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                if (movie.genres.isEmpty)
                  Text(l10n.noGenres)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres.map((genre) {
                      return Chip(label: Text(genre.name));
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  final String label;
  final String value;

  const _InformationRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
