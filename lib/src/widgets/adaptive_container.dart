import 'package:flutter/widgets.dart';

import '../core/adaptive_scope.dart';
import '../core/screen_config.dart';

/// A container whose margin, padding, border radius, and constraints
/// scale automatically based on [ScreenConfig] scaling factors.
///
/// ```dart
/// AdaptiveContainer(
///   margin: EdgeInsets.all(16),
///   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
///   borderRadius: 12,
///   maxWidth: 600,
///   color: Color(0xFFFFFFFF),
///   child: Text('Hello'),
/// )
/// ```
class AdaptiveContainer extends StatelessWidget {
  /// Creates an [AdaptiveContainer].
  const AdaptiveContainer({
    super.key,
    this.margin,
    this.padding,
    this.borderRadius,
    this.maxWidth,
    this.color,
    this.decoration,
    this.alignment,
    this.width,
    this.height,
    this.child,
  }) : assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration.\n'
          'Use decoration: BoxDecoration(color: ...) instead.',
        );

  /// Margin around the container (scaled).
  final EdgeInsets? margin;

  /// Padding inside the container (scaled).
  final EdgeInsets? padding;

  /// Border radius value (scaled by [ScreenConfig.scaleWidth]).
  final double? borderRadius;

  /// Maximum width constraint (scaled by [ScreenConfig.scaleWidth]).
  final double? maxWidth;

  /// Background color. Cannot be used together with [decoration].
  final Color? color;

  /// Custom decoration. Cannot be used together with [color].
  final BoxDecoration? decoration;

  /// Alignment of the child within the container.
  final AlignmentGeometry? alignment;

  /// Fixed width (scaled by [ScreenConfig.scaleWidth]).
  final double? width;

  /// Fixed height (scaled by [ScreenConfig.scaleHeight]).
  final double? height;

  /// Child widget.
  final Widget? child;

  EdgeInsets? _scaleEdgeInsets(EdgeInsets? insets, ScreenConfig config) {
    if (insets == null) return null;
    return EdgeInsets.only(
      left: insets.left * config.scaleWidth,
      right: insets.right * config.scaleWidth,
      top: insets.top * config.scaleHeight,
      bottom: insets.bottom * config.scaleHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.of(context);

    final scaledMargin = _scaleEdgeInsets(margin, config);
    final scaledPadding = _scaleEdgeInsets(padding, config);
    final scaledRadius = borderRadius != null
        ? BorderRadius.circular(borderRadius! * config.scaleWidth)
        : null;

    BoxDecoration? effectiveDecoration;
    if (decoration != null) {
      effectiveDecoration = decoration!.copyWith(
        borderRadius: scaledRadius ?? decoration!.borderRadius,
      );
    } else if (color != null || scaledRadius != null) {
      effectiveDecoration = BoxDecoration(
        color: color,
        borderRadius: scaledRadius,
      );
    }

    final scaledWidth = width != null ? width! * config.scaleWidth : null;
    final scaledHeight = height != null ? height! * config.scaleHeight : null;
    final scaledMaxWidth =
        maxWidth != null ? maxWidth! * config.scaleWidth : null;

    return Container(
      margin: scaledMargin,
      padding: scaledPadding,
      alignment: alignment,
      decoration: effectiveDecoration,
      constraints: scaledMaxWidth != null
          ? BoxConstraints(maxWidth: scaledMaxWidth)
          : null,
      width: scaledWidth,
      height: scaledHeight,
      child: child,
    );
  }
}
