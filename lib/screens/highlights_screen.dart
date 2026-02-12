import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:focus_journal/services/event_bus.dart';
import 'package:focus_journal/widgets/journal_entry_card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  late final Future<JournalService> _journalService;
  List<JournalEntry>? _entries;
  StreamSubscription<String>? _sub;
  bool _starsEnabled = true;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _loadEntries();
    _sub = AppEventBus().stream.listen((event) {
      if (event == AppEvents.journalChanged) {
        _loadEntries();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final service = await _journalService;
    final entries = await service.getHighlightedEntries();
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _entries = entries;
        _starsEnabled = prefs.getBool('stars_enabled') ?? true;
      });
    }
  }

  Future<void> _toggleStar(String id) async {
    final service = await _journalService;
    await service.toggleHighlight(id);
    await _loadEntries();
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
        title: Text(l10n.highlights),
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_entries == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_entries!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 64,
                color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(l10n.noHighlights,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    final sorted = [..._entries!]
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

      final canToggle = _starsEnabled && entry.isEditableToday;
      widgets.add(
        JournalEntryCard(
          entry: entry,
          showStar: true,
          onToggleStar: canToggle ? () => _toggleStar(entry.id) : null,
          onTap: () => Navigator.of(context).pop(entry.id),
        ),
      );
    }

    return ListView(children: widgets);
  }
}
