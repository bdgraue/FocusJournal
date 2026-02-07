import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/settings/journal_preferences.dart';
import '../../services/journal_preferences_service.dart';

/// Screen for managing journal display and editing preferences.
///
/// Allows users to customize their journal experience including:
/// - Default view mode (calendar/list/timeline)
/// - Entry sort order (newest/oldest/title)
/// - Font size (small/medium/large/extra large)
/// - Display toggles (date headers, tags)
/// - Spell check preference
class JournalPreferencesScreen extends StatelessWidget {
  const JournalPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JournalPreferencesService>(
      future: JournalPreferencesService.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider.value(
            value: snapshot.data!,
            child: const _JournalPreferencesContent(),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _JournalPreferencesContent extends StatefulWidget {
  const _JournalPreferencesContent();

  @override
  State<_JournalPreferencesContent> createState() =>
      _JournalPreferencesContentState();
}

class _JournalPreferencesContentState
    extends State<_JournalPreferencesContent> {
  late JournalPreferencesService _service;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _service = await JournalPreferencesService.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final preferences = context.watch<JournalPreferencesService>().preferences;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.journalPreferences),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // View & Layout Section
          _buildSectionHeader(l10n.viewAndLayout),
          const SizedBox(height: 16),
          _buildDefaultViewSelector(preferences),
          const SizedBox(height: 16),
          _buildSortOrderSelector(preferences),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Display Options Section
          _buildSectionHeader(l10n.displayOptions),
          const SizedBox(height: 16),
          _buildFontSizeSelector(preferences),
          const SizedBox(height: 16),
          _buildDateHeadersToggle(preferences),
          _buildShowTagsToggle(preferences),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Editing Section
          _buildSectionHeader(l10n.editing),
          const SizedBox(height: 16),
          _buildSpellCheckToggle(preferences),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDefaultViewSelector(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.defaultView,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RadioGroup<JournalViewMode>(
          groupValue: preferences.defaultView,
          onChanged: (value) => _service.setDefaultView(value!),
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.calendarView),
                leading: const Radio<JournalViewMode>(
                  value: JournalViewMode.calendar,
                ),
                onTap: () => _service.setDefaultView(JournalViewMode.calendar),
              ),
              ListTile(
                title: Text(l10n.listView),
                leading: const Radio<JournalViewMode>(
                  value: JournalViewMode.list,
                ),
                onTap: () => _service.setDefaultView(JournalViewMode.list),
              ),
              ListTile(
                title: Text(l10n.timelineView),
                leading: const Radio<JournalViewMode>(
                  value: JournalViewMode.timeline,
                ),
                onTap: () => _service.setDefaultView(JournalViewMode.timeline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOrderSelector(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sortOrder,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RadioGroup<EntrySortOrder>(
          groupValue: preferences.sortOrder,
          onChanged: (value) => _service.setSortOrder(value!),
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.newestFirst),
                leading: const Radio<EntrySortOrder>(
                  value: EntrySortOrder.newestFirst,
                ),
                onTap: () => _service.setSortOrder(EntrySortOrder.newestFirst),
              ),
              ListTile(
                title: Text(l10n.oldestFirst),
                leading: const Radio<EntrySortOrder>(
                  value: EntrySortOrder.oldestFirst,
                ),
                onTap: () => _service.setSortOrder(EntrySortOrder.oldestFirst),
              ),
              ListTile(
                title: Text(l10n.titleAscending),
                leading: const Radio<EntrySortOrder>(
                  value: EntrySortOrder.titleAscending,
                ),
                onTap: () =>
                    _service.setSortOrder(EntrySortOrder.titleAscending),
              ),
              ListTile(
                title: Text(l10n.titleDescending),
                leading: const Radio<EntrySortOrder>(
                  value: EntrySortOrder.titleDescending,
                ),
                onTap: () =>
                    _service.setSortOrder(EntrySortOrder.titleDescending),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSelector(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.fontSize,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RadioGroup<FontSize>(
          groupValue: preferences.fontSize,
          onChanged: (value) => _service.setFontSize(value!),
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.fontSizeSmall),
                leading: const Radio<FontSize>(value: FontSize.small),
                onTap: () => _service.setFontSize(FontSize.small),
              ),
              ListTile(
                title: Text(l10n.fontSizeMedium),
                leading: const Radio<FontSize>(value: FontSize.medium),
                onTap: () => _service.setFontSize(FontSize.medium),
              ),
              ListTile(
                title: Text(l10n.fontSizeLarge),
                leading: const Radio<FontSize>(value: FontSize.large),
                onTap: () => _service.setFontSize(FontSize.large),
              ),
              ListTile(
                title: Text(l10n.fontSizeExtraLarge),
                leading: const Radio<FontSize>(value: FontSize.extraLarge),
                onTap: () => _service.setFontSize(FontSize.extraLarge),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeadersToggle(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      title: Text(l10n.showDateHeaders),
      subtitle: Text(l10n.showDateHeadersDescription),
      value: preferences.showDateHeaders,
      onChanged: (value) => _service.setShowDateHeaders(value),
    );
  }

  Widget _buildShowTagsToggle(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      title: Text(l10n.showTags),
      subtitle: Text(l10n.showTagsDescription),
      value: preferences.showTags,
      onChanged: (value) => _service.setShowTags(value),
    );
  }

  Widget _buildSpellCheckToggle(JournalPreferences preferences) {
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      title: Text(l10n.enableSpellCheck),
      subtitle: Text(l10n.enableSpellCheckDescription),
      value: preferences.enableSpellCheck,
      onChanged: (value) => _service.setEnableSpellCheck(value),
    );
  }
}
