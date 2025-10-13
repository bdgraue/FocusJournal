import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'general_settings_screen.dart';
import 'journal_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildJournalTab(), _buildSettingsTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: AppLocalizations.of(context)!.journal,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    return const JournalScreen();
  }

  Widget _buildSettingsTab() {
    return const GeneralSettingsScreen();
  }
}
