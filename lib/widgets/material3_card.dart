import 'package:flutter/material.dart';

/// A Material 3 styled card widget that automatically adapts to light/dark themes.
///
/// In light mode:
/// - Uses minimal elevation (1)
/// - Standard Material 3 surface tint
///
/// In dark mode:
/// - No elevation (0)
/// - No surface tint
/// - Subtle border for better contrast
class Material3Card extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget? child;

  /// The card's margin from the edges.
  final EdgeInsetsGeometry? margin;

  /// The card's background color. If null, uses theme's card color.
  final Color? color;

  /// The z-coordinate at which to place this card. Overrides default theme-aware elevation.
  final double? elevation;

  /// The color to paint the shadow below the card. Only applies in light mode.
  final Color? shadowColor;

  /// The color to use for the card's surface tint. Overrides default theme-aware behavior.
  final Color? surfaceTintColor;

  /// The shape of the card. If null, uses rounded rectangle with 12px radius.
  final ShapeBorder? shape;

  /// Whether this card is semantically a container for a single child or a group of children.
  final bool borderOnBorder;

  /// The semantic label for this card.
  final Clip clipBehavior;

  const Material3Card({
    super.key,
    this.child,
    this.margin,
    this.color,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.borderOnBorder = true,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Material 3 principles:
    // - Light mode: subtle elevation with surface tint
    // - Dark mode: flat design with subtle border
    final effectiveElevation = elevation ?? (isDark ? 0 : 1);
    final effectiveSurfaceTintColor = surfaceTintColor ??
        (isDark ? Colors.transparent : null);

    final effectiveShape = shape ?? RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: isDark
          ? BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
              width: 1,
            )
          : BorderSide.none,
    );

    return Card(
      margin: margin,
      color: color,
      elevation: effectiveElevation,
      shadowColor: shadowColor,
      surfaceTintColor: effectiveSurfaceTintColor,
      shape: effectiveShape,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
