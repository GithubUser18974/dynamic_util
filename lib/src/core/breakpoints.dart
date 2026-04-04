/// Represents a screen size category.
enum Breakpoint {
  /// Small screens (phones): width < 600
  small,

  /// Medium screens (tablets): 600 ≤ width ≤ 1024
  medium,

  /// Large screens (desktops): width > 1024
  large,
}

/// Configuration for breakpoint thresholds.
///
/// Provides customizable width thresholds for categorizing screen sizes.
/// Defaults: small < 600, 600 ≤ medium ≤ 1024, large > 1024.
class BreakpointConfig {
  /// Creates a [BreakpointConfig] with the given thresholds.
  ///
  /// [smallMax] is the upper bound (exclusive) for small screens.
  /// [largeMin] is the lower bound (exclusive) for large screens.
  /// Values between [smallMax] and [largeMin] (inclusive) are medium.
  const BreakpointConfig({
    this.smallMax = 600,
    this.largeMin = 1024,
  }) : assert(smallMax <= largeMin, 'smallMax must be ≤ largeMin');

  /// Returns a [BreakpointConfig] matching Material 3 layout specifications.
  const BreakpointConfig.material3()
      : smallMax = 600,
        largeMin = 840;

  /// Returns a [BreakpointConfig] matching Bootstrap 5 layout conventions.
  const BreakpointConfig.bootstrap()
      : smallMax = 768,
        largeMin = 992;

  /// Returns a [BreakpointConfig] matching Tailwind CSS conventions.
  const BreakpointConfig.tailwind()
      : smallMax = 768,
        largeMin = 1024;

  /// Upper bound (exclusive) for small screens. Default: 600.
  final double smallMax;

  /// Lower bound (exclusive) for large screens. Default: 1024.
  final double largeMin;

  /// Returns the [Breakpoint] for the given [width].
  Breakpoint breakpointForWidth(double width) {
    if (width < smallMax) return Breakpoint.small;
    if (width > largeMin) return Breakpoint.large;
    return Breakpoint.medium;
  }
}

/// Global default breakpoint configuration.
const BreakpointConfig defaultBreakpoints = BreakpointConfig();

/// Utility class with static helper methods for breakpoint detection.
///
/// All methods accept an optional [BreakpointConfig] to allow custom
/// thresholds. When omitted, the [defaultBreakpoints] are used.
class BreakpointHelper {
  BreakpointHelper._();

  /// Returns the current [Breakpoint] for the given screen [width].
  static Breakpoint current(
    double width, {
    BreakpointConfig config = defaultBreakpoints,
  }) {
    return config.breakpointForWidth(width);
  }

  /// Returns `true` if [width] falls in the [Breakpoint.small] range.
  static bool isMobile(
    double width, {
    BreakpointConfig config = defaultBreakpoints,
  }) {
    return config.breakpointForWidth(width) == Breakpoint.small;
  }

  /// Returns `true` if [width] falls in the [Breakpoint.medium] range.
  static bool isTablet(
    double width, {
    BreakpointConfig config = defaultBreakpoints,
  }) {
    return config.breakpointForWidth(width) == Breakpoint.medium;
  }

  /// Returns `true` if [width] falls in the [Breakpoint.large] range.
  static bool isDesktop(
    double width, {
    BreakpointConfig config = defaultBreakpoints,
  }) {
    return config.breakpointForWidth(width) == Breakpoint.large;
  }
}
