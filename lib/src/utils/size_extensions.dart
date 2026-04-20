import 'package:flutter/widgets.dart';
import '../core/adaptive_scope.dart';
import '../core/screen_config.dart';

/// Extension methods on [num] for adaptive sizing.
///
/// These extensions use [ScreenConfig] scaling factors to convert design
/// dimensions into device-appropriate values.
///
/// **Important:** [ScreenConfig.init] must be called before using these
/// extensions.
///
/// ```dart
/// Container(
///   width: 200.w,
///   height: 100.h,
///   child: Text('Hello', style: TextStyle(fontSize: 16.sp)),
/// )
/// ```
extension AdaptiveSize on num {
  /// Returns a width-adapted value.
  ///
  /// Multiplies the number by [ScreenConfig.scaleWidth].
  double get w => toDouble() * ScreenConfig.instance.scaleWidth;

  /// Returns a height-adapted value.
  ///
  /// Multiplies the number by [ScreenConfig.instance.scaleHeight].
  double get h => toDouble() * ScreenConfig.instance.scaleHeight;

  /// Returns a font-scaled value.
  ///
  /// Multiplies the number by [ScreenConfig.instance.scaleText] which is
  /// `min(scaleWidth, scaleHeight)` to prevent text from becoming
  /// disproportionately large.
  double get sp => toDouble() * ScreenConfig.instance.scaleText;

  /// Fluidly scales the value up to [max] between [minWidth] and [maxWidth].
  ///
  /// Uses the global [ScreenConfig.instance].
  double fluid(num max, {num minWidth = 375, num maxWidth = 1024}) {
    final screenWidth = ScreenConfig.instance.screenWidth;
    if (screenWidth <= minWidth) return toDouble();
    if (screenWidth >= maxWidth) return max.toDouble();

    final fraction = (screenWidth - minWidth) / (maxWidth - minWidth);
    return toDouble() + (max - toDouble()) * fraction;
  }
}

/// Extension methods on [BuildContext] for adaptive sizing that responds to
/// [AdaptiveScope]. Use these for fully reactive UIs.
///
/// ```dart
/// Container(
///   width: context.w(200),
///   height: context.h(100),
///   child: Text('Hello', style: TextStyle(fontSize: context.sp(16))),
/// )
/// ```
extension AdaptiveSizeContext on BuildContext {
  /// Returns a width-adapted value that auto-updates if inside an [AdaptiveScope].
  double w(num value) => value.toDouble() * AdaptiveScope.of(this).scaleWidth;

  /// Returns a height-adapted value that auto-updates if inside an [AdaptiveScope].
  double h(num value) => value.toDouble() * AdaptiveScope.of(this).scaleHeight;

  /// Returns a font-scaled value that auto-updates if inside an [AdaptiveScope].
  double sp(num value) => value.toDouble() * AdaptiveScope.of(this).scaleText;

  /// Fluidly scales a value between [min] and [max] based on current screen width.
  ///
  /// Smoothly interpolates the size as the screen expands from [minWidth] to [maxWidth].
  double fluid(num min, num max, {num minWidth = 375, num maxWidth = 1024}) {
    final screenWidth = AdaptiveScope.of(this).screenWidth;
    if (screenWidth <= minWidth) return min.toDouble();
    if (screenWidth >= maxWidth) return max.toDouble();

    final fraction = (screenWidth - minWidth) / (maxWidth - minWidth);
    return min.toDouble() + (max - min).toDouble() * fraction;
  }
}
