import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Shown when stored entries exist but could not be decrypted.
///
/// Deliberately not the "no entries yet" illustration: an empty journal and an
/// unreadable one look identical but mean opposite things, and mistaking the
/// second for the first invites the user to start writing on top of data that
/// is still there.
class EntriesUnreadableNotice extends StatelessWidget {
  const EntriesUnreadableNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: colors.error),
            const SizedBox(height: 16),
            Text(
              l10n.entriesUnreadable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
