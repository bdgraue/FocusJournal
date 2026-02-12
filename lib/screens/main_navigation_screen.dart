import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/event_bus.dart';
import 'calendar_screen.dart';
import 'general_settings_screen.dart';
import 'highlights_screen.dart';
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
  String? _scrollToEntryId;
  bool _starsEnabled = true;
  StreamSubscription<String>? _eventSub;

  @override
  void initState() {
    super.initState();
    _loadStarsEnabled();
    _eventSub = AppEventBus().stream.listen((event) {
      if (event == AppEvents.journalChanged) {
        _loadStarsEnabled();
      }
    });
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  Future<void> _loadStarsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _starsEnabled = prefs.getBool('stars_enabled') ?? true;
      });
    }
  }

  Future<void> _openSearch() async {
    final entryId = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
    if (entryId != null && mounted) {
      setState(() => _scrollToEntryId = entryId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _scrollToEntryId = null);
      });
    }
  }

  Future<void> _openCalendar() async {
    final entryId = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
    if (entryId != null && mounted) {
      setState(() => _scrollToEntryId = entryId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _scrollToEntryId = null);
      });
    }
  }

  Future<void> _openHighlights() async {
    final entryId = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const HighlightsScreen()),
    );
    if (entryId != null && mounted) {
      setState(() => _scrollToEntryId = entryId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _scrollToEntryId = null);
      });
    }
  }

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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'search':
                        _openSearch();
                      case 'calendar':
                        _openCalendar();
                      case 'highlights':
                        _openHighlights();
                      case 'edit':
                        setState(() => _isEditMode = true);
                      case 'settings':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GeneralSettingsScreen(),
                          ),
                        ).then((_) => _loadStarsEnabled());
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'search',
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 12),
                          Text(l10n.search),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'calendar',
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(width: 12),
                          Text(l10n.calendarOverview),
                        ],
                      ),
                    ),
                    if (_starsEnabled)
                      PopupMenuItem(
                        value: 'highlights',
                        child: Row(
                          children: [
                            const Icon(Icons.star_outline),
                            const SizedBox(width: 12),
                            Text(l10n.highlights),
                          ],
                        ),
                      ),
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
      body: JournalScreen(
        isEditMode: _isEditMode,
        scrollToEntryId: _scrollToEntryId,
      ),
    );
  }
}
