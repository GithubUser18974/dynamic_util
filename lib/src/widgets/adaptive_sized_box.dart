import 'package:flutter/widgets.dart';

import '../core/adaptive_scope.dart';
import '../core/screen_config.dart';

/// A [SizedBox] whose dimensions scale automatically based on
/// [ScreenConfig] scaling factors.
///
/// [width] scales with [ScreenConfig.scaleWidth] and [height] scales
/// with [ScreenConfig.scaleHeight].
///
/// ```dart
/// AdaptiveSizedBox(width: 100, height: 50)
/// ```
class AdaptiveSizedBox extends StatelessWidget {
  /// Creates an [AdaptiveSizedBox].
  ///
  /// At least one of [width] or [height] should be provided.
  const AdaptiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  /// The design width (before scaling). Scaled by [ScreenConfig.scaleWidth].
  final double? width;

  /// The design height (before scaling). Scaled by [ScreenConfig.scaleHeight].
  final double? height;

  /// Optional child widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.of(context);
    return SizedBox(
      width: width != null ? width! * config.scaleWidth : null,
      height: height != null ? height! * config.scaleHeight : null,
      child: child,
    );
  }
}
