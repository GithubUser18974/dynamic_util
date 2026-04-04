import 'package:flutter/widgets.dart';
import '../core/adaptive_scope.dart';

/// An adaptive gap widget that automatically scales and determines its main axis
/// when placed inside a [Row] or [Column].
///
/// It uses [AdaptiveScope] factors.
/// Horizontal size scales by `scaleWidth`.
/// Vertical size scales by `scaleHeight`.
///
/// ```dart
/// Column(
///   children: [
///     Text('Item 1'),
///     AdaptiveSpacing(16), // scaled height
///     Text('Item 2'),
///   ],
/// )
/// ```
class AdaptiveSpacing extends StatelessWidget {
  /// The design size of the gap.
  final double size;

  /// Creates an [AdaptiveSpacing].
  const AdaptiveSpacing(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.of(context);
    final direction = _getDirection(context);

    if (direction == Axis.horizontal) {
      return SizedBox(width: size * config.scaleWidth);
    } else {
      return SizedBox(height: size * config.scaleHeight);
    }
  }

  Axis? _getDirection(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<Row>() != null) {
      return Axis.horizontal;
    }
    if (context.findAncestorWidgetOfExactType<Column>() != null) {
      return Axis.vertical;
    }
    final flex = context.findAncestorWidgetOfExactType<Flex>();
    return flex?.direction;
  }
}
