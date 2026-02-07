import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AcknowledgmentsScreen extends StatelessWidget {
  const AcknowledgmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.credits),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: const Text('Deike',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                AppLocalizations.of(context)!.creditsDeike,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
