import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// An adaptive wrapper around [SafeArea].
///
/// Automatically applies the standard [SafeArea] padding on mobile devices
/// (where physical notches and home indicators exist), but gracefully bypasses
/// it on larger desktop/web screens where it is typically unnecessary and can
/// cause unwanted layout indentation.
class AdaptiveSafeArea extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether to avoid system intrusions on the left side of the screen.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right side of the screen.
  final bool right;

  /// Whether to avoid system intrusions at the bottom of the screen, typically the system navigation bar.
  final bool bottom;

  /// The minimum padding to apply.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeArea] should maintain the bottom `MediaQueryData.padding`
  /// instead of consuming it.
  final bool maintainBottomViewPadding;

  /// The breakpoint width at which the view switches from applying [SafeArea] (Mobile)
  /// to bypassing it (Desktop). Defaults to [BreakpointConfig.mediumMin] (600.0).
  final double? breakpoint;

  /// Creates an adaptive [SafeArea].
  const AdaptiveSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final switchBreakpoint =
        breakpoint ?? const BreakpointConfig.material3().smallMax;

    final isDesktop = screenWidth >= switchBreakpoint;

    if (isDesktop) {
      // Desktop/Web apps generally don't need SafeArea padding.
      return child;
    } else {
      // Mobile apps need to dodge notches and home indicators.
      return SafeArea(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        minimum: minimum,
        maintainBottomViewPadding: maintainBottomViewPadding,
        child: child,
      );
    }
  }
}
