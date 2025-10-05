import 'package:flutter/material.dart';
import 'package:focus_journal/services/journal_service.dart';

class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entry; // null for new entry, non-null for editing

  const JournalEntryScreen({super.key, this.entry});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  late final TextEditingController _contentController;
  late final Future<JournalService> _journalService;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _journalService = JournalService.create();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content is required')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final service = await _journalService;
      final entry = JournalEntry(
        id: widget.entry?.id,
        content: _contentController.text.trim(),
        createdAt: widget.entry?.createdAt,
      );

      if (widget.entry != null) {
        await service.updateEntry(entry);
      } else {
        await service.addEntry(entry);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving entry: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isProcessing ? null : _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            hintText: 'Write your thoughts...',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          minLines: 10,
          autofocus: true,
        ),
      ),
    );
  }
}