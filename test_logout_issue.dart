import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/main.dart';

void main() {
  testWidgets('Test duplicate GlobalKey issue during logout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async operations
    await tester.pumpAndSettle();

    // Print current widget tree for debugging
    print('Initial widget tree built');
    
    // Try to simulate the logout scenario that causes duplicate GlobalKey
    // This should reproduce the error mentioned in the issue
    try {
      // Find any logout buttons or elements
      final logoutFinder = find.text('Logout');
      if (logoutFinder.evaluate().isNotEmpty) {
        await tester.tap(logoutFinder);
        await tester.pumpAndSettle();
        print('Logout tap completed');
      } else {
        print('No logout button found - need to authenticate first');
      }
    } catch (e) {
      print('Error during logout: $e');
      if (e.toString().contains('Duplicate GlobalKey detected')) {
        print('REPRODUCED: Duplicate GlobalKey error confirmed!');
      }
    }
  });
}