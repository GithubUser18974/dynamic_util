import 'package:flutter/widgets.dart';

import '../core/adaptive_scope.dart';
import '../core/screen_config.dart';

/// A padding widget whose insets scale automatically based on
/// [ScreenConfig] scaling factors.
///
/// Horizontal values (left, right) scale with [ScreenConfig.scaleWidth],
/// and vertical values (top, bottom) scale with [ScreenConfig.scaleHeight].
///
/// ```dart
/// AdaptivePadding(
///   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
///   child: Text('Hello'),
/// )
/// ```
class AdaptivePadding extends StatelessWidget {
  /// Creates an [AdaptivePadding].
  const AdaptivePadding({
    super.key,
    required this.padding,
    required this.child,
  });

  /// The padding to apply, before scaling.
  ///
  /// Horizontal and vertical components are scaled independently.
  final EdgeInsets padding;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: padding.left * config.scaleWidth,
        right: padding.right * config.scaleWidth,
        top: padding.top * config.scaleHeight,
        bottom: padding.bottom * config.scaleHeight,
      ),
      child: child,
    );
  }
}
