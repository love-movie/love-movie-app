class Movie {
  final int id;

  final String title;

  final int year;

  Movie({required this.id, required this.title, required this.year});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json['id'], title: json['title'], year: json['year']);
  }
}
