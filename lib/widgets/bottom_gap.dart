import 'package:flutter/material.dart';

/// Keeps screen content clear of the Android home/gesture bar.
///
/// Use it as a Scaffold's `bottomNavigationBar`. It is as tall as the
/// system bar plus a small [gap], so content never sits right on the bar.
/// The Scaffold hides it behind the keyboard automatically.
class BottomGap extends StatelessWidget {
  const BottomGap({super.key, this.color, this.gap = 12});

  /// Fill colour; match the bottom of the screen. Defaults to the
  /// Scaffold background showing through.
  final Color? color;

  /// Extra space above the system bar.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final systemBar = MediaQuery.paddingOf(context).bottom;
    return ColoredBox(
      color: color ?? Colors.transparent,
      child: SizedBox(height: systemBar + gap, width: double.infinity),
    );
  }
}
