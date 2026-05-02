import 'package:flutter/widgets.dart';

import '../utils/adaptive_value.dart';

/// A wrapper around [SliverGrid] that automatically adjusts its
/// column count (`crossAxisCount`) based on the current screen breakpoint.
///
/// Use this inside a [CustomScrollView] or [NestedScrollView].
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     AdaptiveSliverGrid(
///       delegate: SliverChildBuilderDelegate(
///         (context, index) => Container(),
///         childCount: 20,
///       ),
///       crossAxisCount: const AdaptiveValue<int>(
///         mobile: 1,
///         tablet: 3,
///         desktop: 5,
///       ),
///     ),
///   ],
/// )
/// ```
class AdaptiveSliverGrid extends StatelessWidget {
  /// The delegate that provides the children for this grid.
  final SliverChildDelegate delegate;

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

  /// Creates an [AdaptiveSliverGrid].
  const AdaptiveSliverGrid({
    super.key,
    required this.delegate,
    this.crossAxisCount = const AdaptiveValue<int>(
      mobile: 1,
      tablet: 2,
      desktop: 4,
    ),
    this.maxColumnWidth,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (maxColumnWidth != null) {
          final width = constraints.crossAxisExtent;
          columns = (width / maxColumnWidth!).floor();
        } else {
          columns = crossAxisCount.resolve(context);
        }

        // Provide a safe fallback minimum of 1 column
        final safeColumns = columns < 1 ? 1 : columns;

        return SliverGrid(
          delegate: delegate,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: safeColumns,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
        );
      },
    );
  }
}
