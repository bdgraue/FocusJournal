import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:focus_journal/services/journal_service.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isEditMode;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? highlightQuery;
  final bool isHighlighted;

  const JournalEntryCard({
    super.key,
    required this.entry,
    this.isEditMode = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.highlightQuery,
    this.isHighlighted = false,
  });

  Widget _buildContent(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat.jm(locale);

    final contentWidget = highlightQuery != null && highlightQuery!.isNotEmpty
        ? _buildHighlightedText(context, entry.content, highlightQuery!)
        : Text(entry.content, softWrap: true);

    final timeWidget = Text(
      timeFormat.format(entry.createdAt),
      style: Theme.of(context).textTheme.bodySmall,
    );

    if (isEditMode) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [contentWidget, const SizedBox(height: 4), timeWidget],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined,
                        size: 20,
                        color: entry.isEditableToday
                            ? null
                            : Theme.of(context).colorScheme.outline.withAlpha(100)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: entry.isEditableToday ? onEdit : null,
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.error),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [contentWidget, const SizedBox(height: 4), timeWidget],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
      BuildContext context, String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: spans,
      ),
      softWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isHighlighted
          ? Theme.of(context).colorScheme.primaryContainer.withAlpha(120)
          : null,
      child: _buildContent(context),
    );
  }
}
