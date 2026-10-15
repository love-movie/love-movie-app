import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:love_movie_app/models/user_preferences.dart';

import '../constants/api_constants.dart';

class UserPreferencesService {
  Future<void> updateLanguage(String languageCode) async {
    debugPrint('[HTTP] PUT /user-preferences');

    debugPrint('[HTTP] language_code=$languageCode');

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/user-preferences'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'language_code': languageCode}),
    );

    debugPrint('[HTTP] status=${response.statusCode}');
    debugPrint('[HTTP] response=${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar idioma.\n'
        'status=${response.statusCode}\n'
        'body=${response.body}',
      );
    }
  }

  Future<UserPreferences> getPreferences() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/user-preferences'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar preferências do usuário');
    }

    final data = jsonDecode(response.body);
    return UserPreferences.fromJson(data);
  }
}
