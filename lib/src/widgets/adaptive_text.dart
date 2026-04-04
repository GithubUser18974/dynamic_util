import 'package:flutter/widgets.dart';

import '../core/adaptive_scope.dart';
import '../core/screen_config.dart';

/// A text widget that automatically scales its font size using
/// [ScreenConfig.scaleText].
///
/// ```dart
/// AdaptiveText(
///   'Hello World',
///   baseFontSize: 16,
///   maxScaleFactor: 1.5,
///   style: TextStyle(fontWeight: FontWeight.bold),
/// )
/// ```
///
/// The effective font size is:
/// ```
/// clamp(baseFontSize * scaleText, baseFontSize * 0.5, baseFontSize * maxScaleFactor)
/// ```
///
/// Set [respectSystemScaling] to `false` to ignore the device's system
/// text scale factor (useful for UI labels that must not grow).
class AdaptiveText extends StatelessWidget {
  /// Creates an [AdaptiveText].
  const AdaptiveText(
    this.text, {
    super.key,
    this.baseFontSize = 14,
    this.maxScaleFactor = 2.0,
    this.minScaleFactor = 0.5,
    this.respectSystemScaling = true,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
  });

  /// The text to display.
  final String text;

  /// Base font size in logical pixels (before scaling). Defaults to 14.
  final double baseFontSize;

  /// Maximum multiplier applied to [baseFontSize]. Defaults to 2.0.
  final double maxScaleFactor;

  /// Minimum multiplier applied to [baseFontSize]. Defaults to 0.5.
  final double minScaleFactor;

  /// Whether to honour the device's system text scale factor.
  /// Defaults to `true`.
  final bool respectSystemScaling;

  /// Optional [TextStyle] merged with the computed font size.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Maximum number of lines.
  final int? maxLines;

  /// How visual overflow is handled.
  final TextOverflow? overflow;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// Text directionality.
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.of(context);
    final scaledSize = baseFontSize * config.scaleText;
    final clampedSize = scaledSize.clamp(
      baseFontSize * minScaleFactor,
      baseFontSize * maxScaleFactor,
    );

    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      fontSize: clampedSize,
    );

    Widget child = Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
    );

    if (!respectSystemScaling) {
      child = MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: child,
      );
    }

    return child;
  }
}
