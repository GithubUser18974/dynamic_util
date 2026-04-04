import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/breakpoints.dart';

/// A widget that automatically switches between [ListView] and [GridView]
/// based on the current screen breakpoint.
///
/// On small screens it renders a [ListView.builder]; on medium and large
/// screens it renders a [GridView.builder] with a dynamically computed
/// `crossAxisCount`.
///
/// ```dart
/// AdaptiveCollectionView(
///   itemCount: items.length,
///   itemBuilder: (context, index) => ItemCard(item: items[index]),
///   gridSpacing: 16,
///   listSpacing: 8,
/// )
/// ```
class AdaptiveCollectionView extends StatelessWidget {
  /// Creates an [AdaptiveCollectionView].
  const AdaptiveCollectionView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.gridSpacing = 8.0,
    this.listSpacing = 8.0,
    this.crossAxisCount,
    this.minTileWidth = 200.0,
    this.childAspectRatio = 1.0,
    this.breakpoints = defaultBreakpoints,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
  });

  /// Builder for each item in the list/grid.
  final IndexedWidgetBuilder itemBuilder;

  /// Total number of items.
  final int itemCount;

  /// Spacing between items in grid mode (both main and cross axis).
  final double gridSpacing;

  /// Spacing between items in list mode.
  final double listSpacing;

  /// Explicit cross-axis count for the grid. If `null`, it is computed
  /// dynamically from the available width and [minTileWidth].
  final int? crossAxisCount;

  /// Minimum width of each grid tile when [crossAxisCount] is auto-calculated.
  /// Defaults to 200.
  final double minTileWidth;

  /// Aspect ratio of each grid tile. Defaults to 1.0.
  final double childAspectRatio;

  /// Custom breakpoint thresholds. Defaults to [defaultBreakpoints].
  final BreakpointConfig breakpoints;

  /// Optional padding around the collection.
  final EdgeInsetsGeometry? padding;

  /// Scroll direction. Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view should shrink-wrap its content.
  final bool shrinkWrap;

  /// Scroll physics override.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final breakpoint = breakpoints.breakpointForWidth(width);

        if (breakpoint == Breakpoint.small) {
          return _buildListView();
        }
        return _buildGridView(width);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < itemCount - 1 ? listSpacing : 0,
          ),
          child: itemBuilder(context, index),
        );
      },
    );
  }

  Widget _buildGridView(double availableWidth) {
    final columns =
        crossAxisCount ?? math.max(2, (availableWidth / minTileWidth).floor());

    return GridView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: gridSpacing,
        crossAxisSpacing: gridSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
