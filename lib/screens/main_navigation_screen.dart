import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'general_settings_screen.dart';
import 'journal_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.settings,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GeneralSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const JournalScreen(),
    );
  }
}
