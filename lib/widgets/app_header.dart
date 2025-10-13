import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final double iconSize;
  final String title;
  final EdgeInsetsGeometry padding;

  const AppHeader({
    super.key,
    this.iconSize = 80,
    this.title = 'Focus Journal',
    this.padding = const EdgeInsets.only(top: 32, bottom: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/journal-icon.png',
              width: iconSize,
              height: iconSize,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
