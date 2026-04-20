import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// A widget that implements the Master-Detail pattern.
///
/// Automatically switches between a split-view layout on wide screens
/// and an animated stacked layout on small screens.
class AdaptiveMasterDetail<T> extends StatefulWidget {
  /// Builder for the master/list pane.
  /// Provides an [onSelect] callback to notify the widget when an item changes.
  final Widget Function(BuildContext context, void Function(T item) onSelect)
      masterBuilder;

  /// Builder for the detail pane, receiving the [selectedItem].
  /// On mobile, an [onBack] callback is provided to dismiss the detail view.
  final Widget Function(
    BuildContext context,
    T? selectedItem, {
    VoidCallback? onBack,
  }) detailBuilder;

  /// The breakpoint threshold for wide screen (split view).
  /// Defaults to [BreakpointConfig.masterDetailSplit].
  final double? breakpoint;

  /// The initially selected item, if any.
  final T? initialSelection;

  /// Width of the master pane in split view.
  final double masterPaneWidth;

  const AdaptiveMasterDetail({
    super.key,
    required this.masterBuilder,
    required this.detailBuilder,
    this.initialSelection,
    this.breakpoint,
    this.masterPaneWidth = 320.0,
  });

  @override
  State<AdaptiveMasterDetail<T>> createState() =>
      _AdaptiveMasterDetailState<T>();
}

class _AdaptiveMasterDetailState<T> extends State<AdaptiveMasterDetail<T>> {
  T? _selectedItem;
  bool _showDetailOnMobile = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelection;
  }

  void _handleSelect(T item) {
    setState(() {
      _selectedItem = item;
      _showDetailOnMobile = true;
    });
  }

  void _handleBack() {
    setState(() {
      _showDetailOnMobile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final splitThreshold =
        widget.breakpoint ?? BreakpointConfig.material3().smallMax;

    final isDesktop = screenWidth >= splitThreshold;

    if (isDesktop) {
      // Split View
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: widget.masterPaneWidth,
            child: widget.masterBuilder(context, _handleSelect),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: widget.detailBuilder(
              context,
              _selectedItem,
              // No back callback needed on desktop
              onBack: null,
            ),
          ),
        ],
      );
    } else {
      // Stacked View (Mobile)
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final isDetail = child.key == const ValueKey('detail');
          final slide = Tween<Offset>(
            begin: isDetail ? const Offset(1, 0) : const Offset(-0.2, 0),
            end: Offset.zero,
          ).animate(animation);

          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
        child: _showDetailOnMobile && _selectedItem != null
            ? KeyedSubtree(
                key: const ValueKey('detail'),
                child: widget.detailBuilder(
                  context,
                  _selectedItem,
                  onBack: _handleBack,
                ),
              )
            : KeyedSubtree(
                key: const ValueKey('master'),
                child: widget.masterBuilder(context, _handleSelect),
              ),
      );
    }
  }
}
