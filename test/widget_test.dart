// Basic Flutter widget test for Focus Journal
//
// Smoke test to verify the app launches without crashing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_journal/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Pump a few frames to allow initial rendering
    await tester.pump();

    // Verify that the app loads without crashing (first shows loading screen)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App loads theme service and shows UI', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Pump frames to allow ThemeService to load
    await tester.pump();
    await tester.pump();
    await tester.pump();

    // Should show scaffolds after theme loads (auth or main screen)
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}
