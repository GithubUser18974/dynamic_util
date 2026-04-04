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
}
