import 'package:flutter/widgets.dart';

import '../core/breakpoints.dart';
import '../utils/adaptive_value.dart';

/// A widget that conventionally switches between a [Row] on large screens
/// and a [Column] on narrow screens.
///
/// By default, it renders a [Row] on tablets and desktops, and a [Column]
/// on mobile.
///
/// ```dart
/// AdaptiveWrap(
///   spacing: 16.w(context), // use context extension to scale the gap
///   children: [
///     Expanded(child: _PanelOne()),
///     Expanded(child: _PanelTwo()),
///   ],
/// )
/// ```
class AdaptiveWrap extends StatelessWidget {
  /// The collection of widgets to arrange.
  final List<Widget> children;

  /// The minimum breakpoint required to arrange children in a [Row].
  ///
  /// Defaults to [Breakpoint.medium].
  final Breakpoint minRowBreakpoint;

  /// The spacing (gap) inserted between children.
  final double spacing;

  /// Row cross-axis alignment. Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment rowCrossAxisAlignment;

  /// Column cross-axis alignment. Defaults to [CrossAxisAlignment.stretch].
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// Row main-axis alignment. Defaults to [MainAxisAlignment.start].
  final MainAxisAlignment rowMainAxisAlignment;

  /// Column main-axis alignment. Defaults to [MainAxisAlignment.start].
  final MainAxisAlignment columnMainAxisAlignment;

  /// Creates an [AdaptiveWrap].
  const AdaptiveWrap({
    super.key,
    required this.children,
    this.minRowBreakpoint = Breakpoint.medium,
    this.spacing = 0.0,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final useRow = AdaptiveValue<bool>(
      mobile: minRowBreakpoint == Breakpoint.small,
      tablet: minRowBreakpoint != Breakpoint.large,
      desktop: true,
    ).resolve(context);

    if (useRow) {
      return Row(
        crossAxisAlignment: rowCrossAxisAlignment,
        mainAxisAlignment: rowMainAxisAlignment,
        children: spacing > 0
            ? _addSpacing(children, spacing, isRow: true)
            : children,
      );
    } else {
      return Column(
        crossAxisAlignment: columnCrossAxisAlignment,
        mainAxisAlignment: columnMainAxisAlignment,
        children: spacing > 0
            ? _addSpacing(children, spacing, isRow: false)
            : children,
      );
    }
  }

  List<Widget> _addSpacing(List<Widget> items, double gap,
      {required bool isRow}) {
    if (items.isEmpty) return const [];
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(SizedBox(
          width: isRow ? gap : null,
          height: !isRow ? gap : null,
        ));
      }
    }
    return result;
  }
}
