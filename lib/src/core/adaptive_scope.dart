import 'package:flutter/widgets.dart';

import 'screen_config.dart';

/// A widget that provides a [ScreenConfig] to its subtree and optionally
/// constrains the width of its content.
///
/// Use this to make your app fully responsive to window resizes
/// by combining it with [ScreenConfig.watch].
///
/// If [maxContentWidth] is provided, the child will be centered and
/// constrained to this width on screens that are wider.
class AdaptiveScope extends StatelessWidget {
  /// Creates an [AdaptiveScope].
  const AdaptiveScope({
    super.key,
    required this.config,
    this.maxContentWidth,
    required this.child,
  });

  /// The [ScreenConfig] provided to the subtree.
  final ScreenConfig config;

  /// The maximum width the content is allowed to take.
  /// If the screen is wider, the content will be centered.
  final double? maxContentWidth;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Returns the nearest [ScreenConfig] from the given [context], or `null`
  /// if no [AdaptiveScope] is found.
  static ScreenConfig? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_InheritedAdaptiveScope>();
    return scope?.config;
  }

  /// Returns the nearest [ScreenConfig] from the given [context].
  ///
  /// Falls back to the global [ScreenConfig.instance] if no [AdaptiveScope]
  /// is found.
  static ScreenConfig of(BuildContext context) {
    final config = maybeOf(context);
    if (config != null) return config;

    assert(
      ScreenConfig.isInitialized,
      'No AdaptiveScope found in context, and global ScreenConfig is not initialized. '
      'Either wrap your widget tree in an AdaptiveScope or call ScreenConfig.init(context).',
    );
    return ScreenConfig.instance;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (maxContentWidth != null && config.screenWidth > maxContentWidth!) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth!),
          child: child,
        ),
      );
    }

    return _InheritedAdaptiveScope(
      config: config,
      child: content,
    );
  }
}

class _InheritedAdaptiveScope extends InheritedWidget {
  const _InheritedAdaptiveScope({
    required this.config,
    required super.child,
  });

  final ScreenConfig config;

  @override
  bool updateShouldNotify(_InheritedAdaptiveScope oldWidget) {
    return config != oldWidget.config;
  }
}
