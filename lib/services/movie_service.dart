import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/movie.dart';

class MovieService {
  Future<List<Movie>> getMovies() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/movies'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar filmes');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((item) => Movie.fromJson(item)).toList();
  }
}
