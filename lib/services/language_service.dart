import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/language.dart';

class LanguageService {
  Future<List<Language>> getLanguages() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/languages'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Language.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load languages');
    }
  }
  // Add your service methods here
}
