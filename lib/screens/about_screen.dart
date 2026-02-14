import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static const _installDateKey = 'app_install_date';
  static const _lastUpdateDateKey = 'app_last_update_date';
  static const _lastVersionKey = 'app_last_version';

  String _version = '';
  String _installDate = '';
  String _updateDate = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    // Track install date (set once, never overwritten)
    if (!prefs.containsKey(_installDateKey)) {
      await prefs.setString(_installDateKey, now);
    }

    // Track update date (set when version changes)
    final storedVersion = prefs.getString(_lastVersionKey);
    if (storedVersion != info.version) {
      await prefs.setString(_lastUpdateDateKey, now);
      await prefs.setString(_lastVersionKey, info.version);
    }

    if (mounted) {
      setState(() {
        _version = info.version;
        _installDate = _formatDate(prefs.getString(_installDateKey) ?? now);
        _updateDate = _formatDate(prefs.getString(_lastUpdateDateKey) ?? now);
      });
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMMd(locale).format(date);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutApp),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Version info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(l10n.appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(l10n.version, _version),
                  const SizedBox(height: 8),
                  _buildInfoRow(l10n.installedOn, _installDate),
                  const SizedBox(height: 8),
                  _buildInfoRow(l10n.lastUpdated, _updateDate),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Developer info
          Card(
            child: ListTile(
              leading: Icon(Icons.code,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(l10n.developer,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Marc Cheng'),
                  Text('bdgraue@tutamail.com'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Self-thanks
          Card(
            child: ListTile(
              leading: Icon(Icons.self_improvement,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Marc',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.creditsSelf),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
