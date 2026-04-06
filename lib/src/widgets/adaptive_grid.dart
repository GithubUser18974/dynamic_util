import 'package:flutter/widgets.dart';

import '../utils/adaptive_value.dart';

/// A wrapper around [GridView.builder] that automatically adjusts its
/// column count (`crossAxisCount`) based on the current screen breakpoint.
///
/// ```dart
/// AdaptiveGrid(
///   itemCount: 20,
///   crossAxisCount: const AdaptiveValue<int>(
///     mobile: 1,
///     tablet: 3,
///     desktop: 5,
///   ),
///   itemBuilder: (context, index) => Container(),
/// )
/// ```
class AdaptiveGrid extends StatelessWidget {
  /// The total number of items to display.
  final int itemCount;

  /// A builder that creates a widget for a given index.
  final NullableIndexedWidgetBuilder itemBuilder;

  /// An [AdaptiveValue] that dictates the number of columns (cross axis count)
  /// for the respective breakpoints.
  ///
  /// This is used if [maxColumnWidth] is `null`.
  final AdaptiveValue<int> crossAxisCount;

  /// If provided, the grid will automatically calculate [crossAxisCount]
  /// such that each column is approximately this wide.
  ///
  /// Takes priority over [crossAxisCount].
  final double? maxColumnWidth;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// Empty space to inscribe inside the grid.
  final EdgeInsetsGeometry? padding;

  /// The axis along which the scroll view scrolls. Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  final bool shrinkWrap;

  /// Creates an [AdaptiveGrid].
  const AdaptiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = const AdaptiveValue<int>(
      mobile: 1,
      tablet: 2,
      desktop: 4,
    ),
    this.maxColumnWidth,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (maxColumnWidth != null) {
          final width = constraints.maxWidth;
          columns = (width / maxColumnWidth!).floor();
        } else {
          columns = crossAxisCount.resolve(context);
        }

        // Provide a safe fallback minimum of 1 column
        final safeColumns = columns < 1 ? 1 : columns;

        return GridView.builder(
          itemCount: itemCount,
          scrollDirection: scrollDirection,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: safeColumns,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
