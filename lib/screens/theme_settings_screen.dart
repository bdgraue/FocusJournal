import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeService>(
      future: ThemeService.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider.value(
            value: snapshot.data!,
            child: const _ThemeSettingsContent(),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ThemeSettingsContent extends StatefulWidget {
  const _ThemeSettingsContent();

  @override
  State<_ThemeSettingsContent> createState() => _ThemeSettingsContentState();
}

class _ThemeSettingsContentState extends State<_ThemeSettingsContent> {
  /// Der Dienst kommt aus dem ChangeNotifierProvider, den
  /// [ThemeSettingsScreen] um dieses Widget legt — er steht damit schon beim
  /// ersten build() bereit. Ihn hier ein zweites Mal asynchron zu holen ließ
  /// den ersten Frame auf ein noch nicht gesetztes late-Feld laufen
  /// (LateInitializationError).
  ThemeService get _themeService => context.read<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.themeSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeModeSection(),
          const SizedBox(height: 16),
          _buildDynamicThemingToggle(),
        ],
      ),
    );
  }

  Widget _buildThemeModeSection() {
    final themeMode = _themeService.getThemeMode();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.appearance,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioGroup<ThemeMode>(
          groupValue: themeMode,
          onChanged: (value) => _updateThemeMode(value!),
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.systemTheme),
                leading: Radio<ThemeMode>(value: ThemeMode.system),
                onTap: () => _updateThemeMode(ThemeMode.system),
              ),
              ListTile(
                title: Text(l10n.lightMode),
                leading: Radio<ThemeMode>(value: ThemeMode.light),
                onTap: () => _updateThemeMode(ThemeMode.light),
              ),
              ListTile(
                title: Text(l10n.darkMode),
                leading: Radio<ThemeMode>(value: ThemeMode.dark),
                onTap: () => _updateThemeMode(ThemeMode.dark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicThemingToggle() {
    final settings = _themeService.themeSettings;
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      title: Text(l10n.dynamicTheming),
      subtitle: Text(l10n.dynamicThemingDescription),
      value: settings.useDynamicTheming,
      onChanged: (value) => _updateDynamicTheming(value),
    );
  }

  Future<void> _updateThemeMode(ThemeMode mode) async {
    await _themeService.setThemeMode(mode);
    setState(() {});
  }

  Future<void> _updateDynamicTheming(bool enabled) async {
    await _themeService.setDynamicTheming(enabled);
    setState(() {});
  }
}
