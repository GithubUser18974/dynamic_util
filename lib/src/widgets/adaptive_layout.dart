import 'package:flutter/widgets.dart';

import '../core/breakpoints.dart';

/// A widget that renders different children based on the current screen
/// breakpoint.
///
/// Provides a simple declarative API for breakpoint-driven layout switching:
///
/// ```dart
/// AdaptiveLayout(
///   mobile: MobileView(),
///   tablet: TabletView(),
///   desktop: DesktopView(),
/// )
/// ```
///
/// **Fallback behavior:**
/// - If [desktop] is `null`, falls back to [tablet], then [mobile].
/// - If [tablet] is `null`, falls back to [mobile].
///
/// Uses [LayoutBuilder] so it responds to the widget's available width,
/// not just the screen width. This makes it composable inside split views.
class AdaptiveLayout extends StatelessWidget {
  /// Creates an [AdaptiveLayout].
  ///
  /// [mobile] is required and serves as the ultimate fallback.
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.mobileLandscape,
    this.tablet,
    this.tabletLandscape,
    this.desktop,
    this.desktopLandscape,
    this.breakpoints = defaultBreakpoints,
  });

  /// Widget to display on small screens (width < [BreakpointConfig.smallMax]).
  final Widget mobile;

  /// Widget to display on small screens in landscape. Falls back to [mobile].
  final Widget? mobileLandscape;

  /// Widget to display on medium screens.
  /// Falls back to [mobile] if `null`.
  final Widget? tablet;

  /// Widget to display on medium screens in landscape. Falls back to [tablet].
  final Widget? tabletLandscape;

  /// Widget to display on large screens.
  /// Falls back to [tablet] → [mobile] if `null`.
  final Widget? desktop;

  /// Widget to display on large screens in landscape. Falls back to [desktop].
  final Widget? desktopLandscape;

  /// Custom breakpoint thresholds. Defaults to [defaultBreakpoints].
  final BreakpointConfig breakpoints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final breakpoint = breakpoints.breakpointForWidth(width);

        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        switch (breakpoint) {
          case Breakpoint.large:
            if (isLandscape && desktopLandscape != null)
              return desktopLandscape!;
            return desktop ?? tablet ?? mobile;
          case Breakpoint.medium:
            if (isLandscape && tabletLandscape != null) return tabletLandscape!;
            return tablet ?? mobile;
          case Breakpoint.small:
            if (isLandscape && mobileLandscape != null) return mobileLandscape!;
            return mobile;
        }
      },
    );
  }
}
