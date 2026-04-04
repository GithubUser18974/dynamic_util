import 'package:flutter/widgets.dart';

import 'screen_config.dart';

/// An [InheritedWidget] that provides a [ScreenConfig] to its subtree.
///
/// Use this to create entirely different design bases for specific areas
/// of your app, or to make your app fully responsive to window resizes
/// by combining it with [ScreenConfig.watch].
///
/// ```dart
/// AdaptiveScope(
///   config: ScreenConfig.watch(context),
///   child: const MyApp(),
/// )
/// ```
class AdaptiveScope extends InheritedWidget {
  /// Creates an [AdaptiveScope].
  const AdaptiveScope({
    super.key,
    required this.config,
    required super.child,
  });

  /// The [ScreenConfig] provided to the subtree.
  final ScreenConfig config;

  /// Returns the nearest [ScreenConfig] from the given [context], or `null`
  /// if no [AdaptiveScope] is found.
  static ScreenConfig? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AdaptiveScope>();
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
  bool updateShouldNotify(AdaptiveScope oldWidget) {
    return config != oldWidget.config;
  }
}
