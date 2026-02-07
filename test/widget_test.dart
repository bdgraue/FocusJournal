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

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App uses Material3 design', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.useMaterial3, isTrue);
    expect(materialApp.darkTheme?.useMaterial3, isTrue);
  });

  testWidgets('App shows a scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Should show a scaffold (either auth or main screen)
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}
