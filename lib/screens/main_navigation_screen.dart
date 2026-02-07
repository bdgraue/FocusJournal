import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'calendar_screen.dart';
import 'general_settings_screen.dart';
import 'journal_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigationScreen({super.key, required this.onLogout});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: _isEditMode
            ? [
                IconButton(
                  icon: const Icon(Icons.done),
                  tooltip: l10n.done,
                  onPressed: () => setState(() => _isEditMode = false),
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: l10n.search,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  tooltip: l10n.calendarOverview,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CalendarScreen(),
                      ),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      setState(() => _isEditMode = true);
                    } else if (value == 'settings') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GeneralSettingsScreen(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined),
                          const SizedBox(width: 12),
                          Text(l10n.editEntries),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined),
                          const SizedBox(width: 12),
                          Text(l10n.settings),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
      ),
      body: JournalScreen(isEditMode: _isEditMode),
    );
  }
}
