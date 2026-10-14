import 'genre.dart';

class Movie {
  final int id;

  final int year;

  final String title;

  final String originalLanguageCode;

  final List<Genre> genres;

  Movie({
    required this.id,
    required this.year,
    required this.title,
    required this.originalLanguageCode,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      year: json['year'],
      title: json['title'],
      originalLanguageCode: json['original_language_code'],

      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }
}
