import 'package:flutter/material.dart';

import '../models/language.dart';
import '../services/language_service.dart';
import '../services/user_preferences_service.dart';
import '../models/user_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LanguageService _languageService = LanguageService();

  final UserPreferencesService _userPreferencesService =
      UserPreferencesService();

  List<Language> _languages = [];

  String? _selectedLanguageCode;

  bool _isLoading = true;
  bool _isSaving = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    debugPrint('[SettingsScreen] initState()');

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint('[SettingsScreen] carregando configurações...');

    try {
      final results = await Future.wait([
        _languageService.getLanguages(),
        _userPreferencesService.getPreferences(),
      ]);

      debugPrint(
        '[SettingsScreen] idiomas carregados: '
        '${(results[0] as List<Language>).length}',
      );

      debugPrint(
        '[SettingsScreen] preferências carregadas: '
        '${(results[1] as UserPreferences).languageCode}',
      );

      final languages = results[0] as List<Language>;
      final preferences = results[1] as UserPreferences;

      if (!mounted) {
        return;
      }

      setState(() {
        _languages = languages;
        _selectedLanguageCode = preferences.languageCode;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('[SettingsScreen] ERRO: $error');
      debugPrint(stackTrace.toString());
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Não foi possível carregar as configurações.\n$error';

        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    debugPrint(
      '[SettingsScreen] salvando idioma '
      '$_selectedLanguageCode',
    );

    final selectedLanguageCode = _selectedLanguageCode;

    if (selectedLanguageCode == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecione um idioma.')));

      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _userPreferencesService.updateLanguage(selectedLanguageCode);
      debugPrint('[SettingsScreen] idioma salvo com sucesso');
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Idioma atualizado com sucesso.')),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Não foi possível atualizar o idioma.\n$error';

        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _languages.isEmpty) {
      return _buildLoadingError();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Idioma',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Escolha o idioma utilizado para exibir '
            'os títulos e os gêneros dos filmes.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            initialValue: _selectedLanguageCode,
            decoration: const InputDecoration(
              labelText: 'Idioma',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.language),
            ),
            items: _languages.map((language) {
              return DropdownMenuItem<String>(
                value: language.code,
                child: Text(language.name),
              );
            }).toList(),
            onChanged: _isSaving
                ? null
                : (value) {
                    setState(() {
                      _selectedLanguageCode = value;
                    });
                  },
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingError() {
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

            Text(_errorMessage!, textAlign: TextAlign.center),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: _loadSettings,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
