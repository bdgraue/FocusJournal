import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _initializeThemeService();
  }

  Future<void> _initializeThemeService() async {
    _themeService = await ThemeService.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.themeSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeModeSection(),
          const Divider(),
          _buildColorSection(),
          const Divider(),
          _buildFontSection(),
          const Divider(),
          _buildAdvancedSection(),
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
        RadioListTile<ThemeMode>(
          title: Text(l10n.systemTheme),
          value: ThemeMode.system,
          groupValue: themeMode,
          onChanged: (value) => _updateThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.lightMode),
          value: ThemeMode.light,
          groupValue: themeMode,
          onChanged: (value) => _updateThemeMode(value!),
        ),
        RadioListTile<ThemeMode>(
          title: Text(l10n.darkMode),
          value: ThemeMode.dark,
          groupValue: themeMode,
          onChanged: (value) => _updateThemeMode(value!),
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    final settings = _themeService.themeSettings;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.colors,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(l10n.primaryColor),
          trailing: _ColorButton(
            color: settings.primaryColor,
            onColorSelected: (color) => _updatePrimaryColor(color),
          ),
        ),
        ListTile(
          title: Text(l10n.accentColor),
          trailing: _ColorButton(
            color: settings.accentColor,
            onColorSelected: (color) => _updateAccentColor(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSection() {
    final settings = _themeService.themeSettings;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.typography,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text(l10n.useCustomFont),
          value: settings.useCustomFont,
          onChanged: (value) => _updateFontSettings(useCustomFont: value),
        ),
        if (settings.useCustomFont)
          ListTile(
            title: Text(l10n.fontFamily),
            trailing: DropdownButton<String>(
              value: settings.customFontFamily ?? 'Roboto',
              items: ['Roboto', 'Lato', 'Open Sans', 'Montserrat', 'Poppins']
                  .map((font) {
                    return DropdownMenuItem(value: font, child: Text(font));
                  })
                  .toList(),
              onChanged: (value) =>
                  _updateFontSettings(customFontFamily: value),
            ),
          ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    final settings = _themeService.themeSettings;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.advancedSettings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text(l10n.dynamicTheming),
          subtitle: Text(l10n.dynamicThemingDescription),
          value: settings.useDynamicTheming,
          onChanged: (value) => _themeService.setDynamicTheming(value),
        ),
        ListTile(
          title: Text(l10n.contrastLabel),
          subtitle: Slider(
            value: settings.contrastLevel,
            min: 0.0,
            max: 2.0,
            divisions: 20,
            label: settings.contrastLevel.toStringAsFixed(1),
            onChanged: (value) => _themeService.setContrastLevel(value),
          ),
        ),
      ],
    );
  }

  Future<void> _updateThemeMode(ThemeMode mode) async {
    await _themeService.updateThemeSettings(
      _themeService.themeSettings.copyWith(themeMode: mode),
    );
    setState(() {});
  }

  Future<void> _updatePrimaryColor(Color color) async {
    await _themeService.updatePrimaryColor(color);
    setState(() {});
  }

  Future<void> _updateAccentColor(Color color) async {
    await _themeService.updateAccentColor(color);
    setState(() {});
  }

  Future<void> _updateFontSettings({
    bool? useCustomFont,
    String? customFontFamily,
  }) async {
    await _themeService.updateFontSettings(
      useCustomFont: useCustomFont,
      customFontFamily: customFontFamily,
    );
    setState(() {});
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorSelected;

  const _ColorButton({required this.color, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.pickAColor),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: color,
              onColorChanged: (color) {
                onColorSelected(color);
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
