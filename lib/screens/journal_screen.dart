import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:intl/intl.dart';
import 'journal_entry_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late final Future<JournalService> _journalService;
  List<JournalEntry>? _entries;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService.create();
    _loadEntries();
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

  Future<void> _deleteEntry(String id) async {
    final service = await _journalService;
    await service.deleteEntry(id);
    await _loadEntries();
  }

  Widget _buildEntryCard(JournalEntry entry) {
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(
          entry.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${dateFormat.format(entry.createdAt)} at ${timeFormat.format(entry.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
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

  Future<void> _createNewEntry() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const JournalEntryScreen(),
      ),
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
              : ListView.builder(
                  itemCount: _entries!.length,
                  itemBuilder: (context, index) => _buildEntryCard(_entries![index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}