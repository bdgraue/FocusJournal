import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/l10n/app_localizations.dart';

/// Wraps a widget with MaterialApp for testing.
///
/// Provides basic Material theme and navigator context.
Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

/// Pumps a widget with full localization support.
///
/// Includes all supported locales and localization delegates.
/// Use this for testing widgets that use AppLocalizations.
Future<void> pumpWidgetWithLocalization(
  WidgetTester tester,
  Widget widget,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget,
    ),
  );
}
