import 'package:flutter/widgets.dart';
import '../core/adaptive_scope.dart';
import '../core/breakpoints.dart';

/// A typed value that resolves differently depending on the current breakpoint.
///
/// Use this for non-widget properties like padding, colors, counts, or sizes
/// that need to change based on the screen size.
///
/// ```dart
/// final padding = AdaptiveValue<double>(
///   mobile: 16,
///   tablet: 24,
///   desktop: 32,
/// ).resolve(context);
/// ```
class AdaptiveValue<T> {
  /// The value to use on small screens (width < [BreakpointConfig.smallMax]).
  /// Required as the ultimate fallback.
  final T mobile;

  /// The value to use on medium screens. Falls back to [mobile] if `null`.
  final T? tablet;

  /// The value to use on large screens. Falls back to [tablet] → [mobile] if `null`.
  final T? desktop;

  /// Custom breakpoint thresholds. Defaults to [defaultBreakpoints].
  final BreakpointConfig breakpoints;

  /// Creates an [AdaptiveValue].
  const AdaptiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoints = defaultBreakpoints,
  });

  /// Resolves the value based on the current screen width obtained from [AdaptiveScope].
  T resolve(BuildContext context) {
    final screenConfig = AdaptiveScope.of(context);
    final width = screenConfig.screenWidth;
    final breakpoint = breakpoints.breakpointForWidth(width);

    switch (breakpoint) {
      case Breakpoint.large:
        return desktop ?? tablet ?? mobile;
      case Breakpoint.medium:
        return tablet ?? mobile;
      case Breakpoint.small:
        return mobile;
    }
  }
}

/// Extension to add `.of(context)` shorthand to [AdaptiveValue].
extension AdaptiveValueContext<T> on AdaptiveValue<T> {
  /// Shorthand for [resolve].
  T of(BuildContext context) => resolve(context);
}
