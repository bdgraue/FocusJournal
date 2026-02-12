import 'package:flutter/material.dart';
import 'dart:async';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:focus_journal/widgets/journal_entry_card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_entry_screen.dart';
import 'package:focus_journal/services/event_bus.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class JournalScreen extends StatefulWidget {
  final bool isEditMode;
  final String? scrollToEntryId;

  const JournalScreen({super.key, this.isEditMode = false, this.scrollToEntryId});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late final Future<JournalService> _journalService;
  List<JournalEntry>? _entries;
  StreamSubscription<String>? _sub;
  final Map<String, GlobalKey> _entryKeys = {};
  String? _highlightedEntryId;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledAway = false;
  bool _starsEnabled = true;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _loadEntries();
    _loadStarsEnabled();
    _sub = AppEventBus().stream.listen((event) {
      if (event == AppEvents.journalChanged) {
        _loadEntries();
        _loadStarsEnabled();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadStarsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _starsEnabled = prefs.getBool('stars_enabled') ?? true;
      });
    }
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 200;
    if (scrolled != _isScrolledAway) {
      setState(() => _isScrolledAway = scrolled);
    }
  }

  @override
  void didUpdateWidget(JournalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollToEntryId != null &&
        widget.scrollToEntryId != oldWidget.scrollToEntryId) {
      _scrollToEntry(widget.scrollToEntryId!);
    }
  }

  Future<void> _loadEntries() async {
    final service = await _journalService;
    final entries = await service.getAllEntries();
    if (mounted) {
      setState(() {
        _entries = entries;
      });
      if (widget.scrollToEntryId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToEntry(widget.scrollToEntryId!);
        });
      }
    }
  }

  void _scrollToEntry(String entryId) {
    final key = _entryKeys[entryId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
      setState(() => _highlightedEntryId = entryId);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _highlightedEntryId = null);
        }
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _deleteEntry(String id) async {
    final service = await _journalService;
    await service.deleteEntry(id);
    await _loadEntries();
  }

  Future<void> _toggleStar(String id) async {
    final service = await _journalService;
    await service.toggleHighlight(id);
    await _loadEntries();
  }

  Widget _buildEntryCard(JournalEntry entry) {
    _entryKeys.putIfAbsent(entry.id, () => GlobalKey());
    final entryKey = _entryKeys[entry.id]!;

    Future<void> openEntry() async {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => JournalEntryScreen(entry: entry),
        ),
      );
      if (result == true) {
        await _loadEntries();
      }
    }

    final canToggleStar = _starsEnabled && entry.isEditableToday;
    final showStar = _starsEnabled && (entry.isEditableToday || entry.isHighlighted);

    return KeyedSubtree(
      key: entryKey,
      child: JournalEntryCard(
        entry: entry,
        isEditMode: widget.isEditMode,
        isHighlighted: _highlightedEntryId == entry.id,
        showStar: showStar,
        onToggleStar: canToggleStar ? () => _toggleStar(entry.id) : null,
        onTap: widget.isEditMode ? openEntry : null,
        onEdit: widget.isEditMode ? openEntry : null,
        onDelete: widget.isEditMode ? () => _deleteEntry(entry.id) : null,
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

  // Using SliverStickyHeader to ensure only the active date stays pinned

  Future<void> _createNewEntry() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const JournalEntryScreen()),
    );
    if (result == true) {
      await _loadEntries();
    }
  }

  // No global sticky logic; SliverPersistentHeader per day handles pinning.

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
                final slivers = <Widget>[];

                // Build pinned header per day followed by its entries
                DateTime? currentHeader;
                final dayEntries = <JournalEntry>[];

                void flushDay() {
                  if (currentHeader == null) return;
                  final entriesForDay = List<JournalEntry>.from(dayEntries);
                  slivers.add(
                    SliverStickyHeader(
                      header: _buildDateHeader(currentHeader),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildEntryCard(entriesForDay[index]),
                          childCount: entriesForDay.length,
                        ),
                      ),
                    ),
                  );
                  dayEntries.clear();
                }

                for (final item in items) {
                  if (item is _DateHeader) {
                    flushDay();
                    currentHeader = item.date;
                  } else if (item is _EntryItem) {
                    dayEntries.add(item.entry);
                  }
                }
                flushDay();

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: slivers,
                );
              },
            ),
      floatingActionButton: _isScrolledAway
          ? FloatingActionButton(
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              child: const Icon(Icons.arrow_upward),
            )
          : FloatingActionButton(
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

// Removed custom sticky header delegate in favor of SliverStickyHeader
