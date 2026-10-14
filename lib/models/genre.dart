class Genre {
  final int id;

  final String code;

  final String name;

  Genre({required this.id, required this.code, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], code: json['code'], name: json['name']);
  }
}
