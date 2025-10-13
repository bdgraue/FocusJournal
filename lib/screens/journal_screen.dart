import 'package:flutter/material.dart';
import 'dart:async';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:intl/intl.dart';
import 'journal_entry_screen.dart';
import 'package:focus_journal/services/event_bus.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late final Future<JournalService> _journalService;
  List<JournalEntry>? _entries;
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _loadEntries();
    // Listen for journal changes (e.g., after import) and refresh
    _sub = AppEventBus().stream.listen((event) {
      if (event == AppEvents.journalChanged) {
        _loadEntries();
      }
    });
  }

  Future<void> _loadEntries() async {
    final service = await _journalService;
    final entries = await service.getAllEntries();
    if (mounted) {
      setState(() {
        _entries = entries;
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _deleteEntry(String id) async {
    final service = await _journalService;
    await service.deleteEntry(id);
    await _loadEntries();
  }

  Widget _buildEntryCard(JournalEntry entry) {
    // Locale-aware time-only formatting for the entry row (explicit locale)
    final locale = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat.jm(locale);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(
          entry.content,
          // Show full content without truncation
          softWrap: true,
        ),
        subtitle: Text(
          timeFormat.format(entry.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        isThreeLine: true,
        onTap: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => JournalEntryScreen(entry: entry),
            ),
          );
          if (result == true) {
            await _loadEntries();
          }
        },
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => JournalEntryScreen(entry: entry),
                  ),
                );
                if (result == true) {
                  await _loadEntries();
                }
              },
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: () => _deleteEntry(entry.id),
            ),
          ],
        ),
      ),
    );
  }

  // --- Grouping helpers: build a mixed list of date headers and entries ---
  DateTime _startOfLocalDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  List<_ListItem> _buildGroupedItems(List<JournalEntry> entries) {
    // Sort by created date desc globally to ensure newest days first
    final sorted = [...entries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final items = <_ListItem>[];
    DateTime? currentDay;
    for (final entry in sorted) {
      final day = _startOfLocalDay(entry.createdAt);
      if (currentDay == null || day != currentDay) {
        currentDay = day;
        items.add(_DateHeader(day));
      }
      items.add(_EntryItem(entry));
    }
    return items;
  }

  String _formatDateHeader(DateTime date) {
    final loc = AppLocalizations.of(context)!;
    final today = _startOfLocalDay(DateTime.now());
    final yesterday = _startOfLocalDay(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final day = _startOfLocalDay(date);
    if (day == today) return loc.today;
    if (day == yesterday) return loc.yesterday;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        _formatDateHeader(date),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  SliverPersistentHeader _buildPinnedHeader(DateTime date) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        minExtent: 44,
        maxExtent: 44,
        child: _buildDateHeader(date),
      ),
    );
  }

  Future<void> _createNewEntry() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const JournalEntryScreen()),
    );
    if (result == true) {
      await _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _entries == null
          ? const Center(child: CircularProgressIndicator())
          : _entries!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.welcomeToJournal,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.journalDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : Builder(
              builder: (context) {
                final items = _buildGroupedItems(_entries!);
                // Transform mixed list into slivers with pinned headers
                final slivers = <Widget>[];
                DateTime? currentHeader;
                final dayEntries = <JournalEntry>[];

                void flushDay() {
                  if (currentHeader == null) return;
                  // Snapshot entries for this day to avoid mutation during build
                  final entriesForDay = List<JournalEntry>.from(dayEntries);
                  slivers.add(_buildPinnedHeader(currentHeader));
                  slivers.add(
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildEntryCard(entriesForDay[index]),
                        childCount: entriesForDay.length,
                      ),
                    ),
                  );
                  dayEntries.clear();
                }

                for (final item in items) {
                  if (item is _DateHeader) {
                    // Header boundary: flush previous day
                    flushDay();
                    currentHeader = item.date;
                  } else if (item is _EntryItem) {
                    dayEntries.add(item.entry);
                  }
                }
                // Flush last day
                flushDay();

                return CustomScrollView(slivers: slivers);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Private helper types for mixed list rendering
abstract class _ListItem {}

class _DateHeader implements _ListItem {
  final DateTime date;
  _DateHeader(this.date);
}

class _EntryItem implements _ListItem {
  final JournalEntry entry;
  _EntryItem(this.entry);
}

// Sticky header delegate
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _minExtent;
  final double _maxExtent;
  final Widget child;

  _HeaderDelegate({
    required double minExtent,
    required double maxExtent,
    required this.child,
  }) : _minExtent = minExtent,
       _maxExtent = maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get minExtent => _minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent ||
        oldDelegate.child != child;
  }
}
