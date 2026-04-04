import 'package:flutter/widgets.dart';

import '../utils/adaptive_value.dart';

/// An image widget that chooses a different [ImageProvider] depending on
/// the current screen breakpoint.
///
/// Useful for serving low-res images to mobile devices and high-res
/// graphics to desktops in order to save bandwidth.
///
/// ```dart
/// AdaptiveImage(
///   mobile: NetworkImage('.../small.jpg'),
///   tablet: NetworkImage('.../medium.jpg'),
///   desktop: NetworkImage('.../large.jpg'),
///   fit: BoxFit.cover,
/// )
/// ```
class AdaptiveImage extends StatelessWidget {
  /// Image for small screens.
  final ImageProvider mobile;

  /// Image for medium screens. Falls back to [mobile].
  final ImageProvider? tablet;

  /// Image for large screens. Falls back to [tablet] → [mobile].
  final ImageProvider? desktop;

  /// Semantic label for the image.
  final String? semanticLabel;

  /// Whether to exclude from semantics.
  final bool excludeFromSemantics;

  /// Image bounding box fit.
  final BoxFit? fit;

  /// Image alignment within its bounds.
  final AlignmentGeometry alignment;

  /// Creates an [AdaptiveImage].
  const AdaptiveImage({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.fit,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final provider = AdaptiveValue<ImageProvider>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).resolve(context);

    return Image(
      image: provider,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      fit: fit,
      alignment: alignment,
    );
  }
}
