// A tiny script to generate simple, clean journal icons as PNGs into assets/.
// Run with: dart run tool/generate_icon.dart
import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) async {
  // Export a square source (1024x1024) so generators can downscale cleanly.
  const size = 1024;

  // Colors
  final bg = img.ColorInt32.rgba(0x2D, 0x6C, 0xDF, 0xFF); // #2D6CDF
  final white = img.ColorInt32.rgba(0xFF, 0xFF, 0xFF, 0xFF);
  final spine = img.ColorInt32.rgba(0xE6, 0xE6, 0xE6, 0xFF); // subtle gray accent
  final lineLight = img.ColorInt32.rgba(0xFF, 0xFF, 0xFF, 0x22); // faint page lines

  // Full icon with colored background
  final full = img.Image(width: size, height: size);
  img.fill(full, color: bg);

  // Journal cover (rounded white card)
  final cardMargin = (size * 0.14).toInt();
  final top = (size * 0.18).toInt();
  final left = cardMargin;
  final right = size - cardMargin - 1; // inclusive
  final bottom = (size * 0.86).toInt();
  final radius = (size * 0.08);

  img.fillRect(full,
      x1: left,
      y1: top,
      x2: right,
      y2: bottom,
      color: white,
      radius: radius);

  // Spine accent on the left
  final spineWidth = (size * 0.06).toInt();
  img.fillRect(full,
      x1: left,
      y1: top,
      x2: left + spineWidth,
      y2: bottom,
      color: spine,
      radius: radius * 0.75);

  // Subtle horizontal page lines
  const lines = 4;
  for (int i = 1; i <= lines; i++) {
    final y = top + ((bottom - top) * (0.25 + i * 0.12)).toInt();
    img.drawLine(full,
        x1: left + spineWidth + (size * 0.06).toInt(),
        y1: y,
        x2: right - (size * 0.08).toInt(),
        y2: y,
        color: lineLight);
  }

  // Ensure assets directory exists
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) assetsDir.createSync(recursive: true);

  // Save full background icon
  File('assets/app_icon.png').writeAsBytesSync(img.encodePng(full));

  // Foreground-only glyph (transparent background) for Android adaptive icon
  final fgImg = img.Image(width: size, height: size);
  img.fill(fgImg, color: img.ColorInt32.rgba(0, 0, 0, 0));

  img.fillRect(fgImg,
      x1: left,
      y1: top,
      x2: right,
      y2: bottom,
      color: white,
      radius: radius);

  img.fillRect(fgImg,
      x1: left,
      y1: top,
      x2: left + spineWidth,
      y2: bottom,
      color: spine,
      radius: radius * 0.75);

  for (int i = 1; i <= lines; i++) {
    final y = top + ((bottom - top) * (0.25 + i * 0.12)).toInt();
    img.drawLine(fgImg,
        x1: left + spineWidth + (size * 0.06).toInt(),
        y1: y,
        x2: right - (size * 0.08).toInt(),
        y2: y,
        color: lineLight);
  }

  File('assets/app_icon_foreground.png')
      .writeAsBytesSync(img.encodePng(fgImg));

  // Monochrome glyph (black on transparent) for Android 13 themed icons
  final mono = img.Image(width: size, height: size);
  final black = img.ColorInt32.rgba(0, 0, 0, 0xFF);
  final lightBlack = img.ColorInt32.rgba(0, 0, 0, 0x55);
  img.fill(mono, color: img.ColorInt32.rgba(0, 0, 0, 0));

  img.fillRect(mono,
      x1: left,
      y1: top,
      x2: right,
      y2: bottom,
      color: black,
      radius: radius);
  img.fillRect(mono,
      x1: left,
      y1: top,
      x2: left + spineWidth,
      y2: bottom,
      color: lightBlack,
      radius: radius * 0.75);
  for (int i = 1; i <= lines; i++) {
    final y = top + ((bottom - top) * (0.25 + i * 0.12)).toInt();
    img.drawLine(mono,
        x1: left + spineWidth + (size * 0.06).toInt(),
        y1: y,
        x2: right - (size * 0.08).toInt(),
        y2: y,
        color: black);
  }

  File('assets/app_icon_monochrome.png')
      .writeAsBytesSync(img.encodePng(mono));

    stdout.writeln('Generated assets/app_icon.png, assets/app_icon_foreground.png, and assets/app_icon_monochrome.png');
}
