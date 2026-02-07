import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:focus_journal/services/event_bus.dart';
import 'package:focus_journal/widgets/journal_entry_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'journal_entry_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final Future<JournalService> _journalService;
  Map<DateTime, List<JournalEntry>> _entriesByDay = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<JournalEntry> _selectedDayEntries = [];
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _selectedDay = DateTime.now();
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
    final grouped = await service.getEntriesGroupedByDay();
    if (mounted) {
      setState(() {
        _entriesByDay = grouped;
        if (_selectedDay != null) {
          final key = DateTime(
            _selectedDay!.year,
            _selectedDay!.month,
            _selectedDay!.day,
          );
          _selectedDayEntries = _entriesByDay[key] ?? [];
          _selectedDayEntries.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );
        }
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedDayEntries = _entriesByDay[key] ?? [];
      _selectedDayEntries.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    });
  }

  List<JournalEntry> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _entriesByDay[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarOverview),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          TableCalendar<JournalEntry>(
            locale: locale,
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const Divider(),
          Expanded(
            child: _selectedDayEntries.isEmpty
                ? Center(
                    child: Text(
                      l10n.noEntriesForDay,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedDayEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _selectedDayEntries[index];
                      return JournalEntryCard(
                        entry: entry,
                        onTap: () async {
                          final result =
                              await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (context) =>
                                  JournalEntryScreen(entry: entry),
                            ),
                          );
                          if (result == true) {
                            _loadEntries();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
