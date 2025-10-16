import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode Sombre'),
            value: themeService.isDarkMode,
            onChanged: (value) {
              themeService.toggleTheme();
            },
          ),
          ListTile(
            title: const Text('Langue'),
            subtitle: const Text('Français (par défaut)'),
            onTap: () {
              // Implémenter sélection de langue
            },
          ),
          ListTile(
            title: const Text('Mode Hors Ligne'),
            subtitle: const Text('Activer les réponses en cache'),
            onTap: () {
              // Implémenter toggle
            },
          ),
          // Ajouter d'autres paramètres comme notifications, etc.
        ],
      ),
    );
  }
}