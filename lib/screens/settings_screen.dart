import 'package:flutter/material.dart';
import 'package:love_movie_app/l10n/app_localizations.dart';
import 'package:love_movie_app/main.dart';

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
        final l10n = AppLocalizations.of(context)!;
        _errorMessage = l10n.settingsLoadError(error);

        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context)!;
    debugPrint(
      '[SettingsScreen] salvando idioma '
      '$_selectedLanguageCode',
    );

    final selectedLanguageCode = _selectedLanguageCode;

    if (selectedLanguageCode == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.selectLanguage)));

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

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.languageUpdated)));

      LoveMovieApp.of(context)?.setLocaleFromLanguageCode(selectedLanguageCode);
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.languageUpdateError(error);

        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.language,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            l10n.chooseLanguage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            initialValue: _selectedLanguageCode,
            decoration: InputDecoration(
              labelText: l10n.language,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.language),
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
              label: Text(_isSaving ? l10n.saveInProgress : l10n.save),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingError() {
    final l10n = AppLocalizations.of(context)!;

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
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
