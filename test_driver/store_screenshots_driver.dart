import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Host-Seite der Store-Screenshot-Erzeugung (Muster: Quirl, Daily Thoughts).
///
/// Nimmt die vom Test per `binding.takeScreenshot(name)` gelieferten Bytes
/// entgegen und legt sie unter `store_assets/screenshots/<name>.png` ab —
/// der Name trägt Sprache, Formfaktor und Design als Unterordner
/// (`de/phone/light/01-journal`). Aufruf siehe store_assets/README.md.
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('store_assets/screenshots/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
