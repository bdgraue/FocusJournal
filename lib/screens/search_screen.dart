import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:focus_journal/services/event_bus.dart';
import 'package:focus_journal/widgets/journal_entry_card.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final Future<JournalService> _journalService;
  final TextEditingController _searchController = TextEditingController();
  List<JournalEntry>? _results;
  Timer? _debounce;
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _sub = AppEventBus().stream.listen((event) {
      if (event == AppEvents.journalChanged && _searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() => _results = null);
      return;
    }
    final service = await _journalService;
    final results = await service.searchEntries(query);
    if (mounted) setState(() => _results = results);
  }

  DateTime _startOfLocalDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  String _formatDateHeader(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final today = _startOfLocalDay(DateTime.now());
    final yesterday =
        _startOfLocalDay(DateTime.now().subtract(const Duration(days: 1)));
    final day = _startOfLocalDay(date);
    if (day == today) return l10n.today;
    if (day == yesterday) return l10n.yesterday;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: l10n.searchEntries,
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _results = null);
              },
            ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_results == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(l10n.searchEntries,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    if (_results!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64,
                color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(l10n.noSearchResults,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    // Group results by date
    final sorted = [..._results!]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final widgets = <Widget>[];
    DateTime? currentDay;

    for (final entry in sorted) {
      final day = _startOfLocalDay(entry.createdAt);
      if (currentDay == null || day != currentDay) {
        currentDay = day;
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              _formatDateHeader(day),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
      widgets.add(
        JournalEntryCard(
          entry: entry,
          highlightQuery: _searchController.text,
          onTap: () => Navigator.of(context).pop(entry.id),
        ),
      );
    }

    return ListView(children: widgets);
  }
}
