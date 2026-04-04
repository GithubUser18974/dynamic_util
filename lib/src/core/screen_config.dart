import 'package:flutter/widgets.dart';

import 'adaptive_scope.dart';

/// Configuration class for screen dimensions and scaling factors.
///
/// Can be used globally via [ScreenConfig.instance] (after calling [ScreenConfig.init]),
/// or locally via [AdaptiveScope.of].
class ScreenConfig {
  /// The reference design width used for scaling calculations.
  final double designWidth;

  /// The reference design height used for scaling calculations.
  final double designHeight;

  /// The actual device screen width.
  final double screenWidth;

  /// The actual device screen height.
  final double screenHeight;

  /// Any safe area insets (like notches or status bars).
  final EdgeInsets safeAreaInsets;

  /// Creates a [ScreenConfig] with explicit dimensions.
  const ScreenConfig({
    required this.designWidth,
    required this.designHeight,
    required this.screenWidth,
    required this.screenHeight,
    this.safeAreaInsets = EdgeInsets.zero,
  });

  /// Scaling factor for width-based dimensions.
  double get scaleWidth => screenWidth / designWidth;

  /// Scaling factor for height-based dimensions.
  double get scaleHeight => screenHeight / designHeight;

  /// Usable height accounting for safe area insets.
  double get safeScreenHeight => screenHeight - safeAreaInsets.vertical;

  /// Scaling factor for height-based dimensions, aware of safe area.
  double get safeScaleHeight => safeScreenHeight / designHeight;

  /// Scaling factor for text/font sizes.
  double get scaleText =>
      (screenWidth / designWidth) < (screenHeight / designHeight)
          ? screenWidth / designWidth
          : screenHeight / designHeight;

  /// Returns `true` if the device is in portrait orientation.
  bool get isPortrait => screenHeight >= screenWidth;

  /// Returns `true` if the device is in landscape orientation.
  bool get isLandscape => screenWidth > screenHeight;

  static ScreenConfig? _instance;

  /// Returns the global fallback [ScreenConfig] instance.
  ///
  /// Throws [StateError] if [init] has not been called yet.
  static ScreenConfig get instance {
    assert(
      _instance != null,
      'Global ScreenConfig has not been initialized. '
      'Call ScreenConfig.init(context) or use AdaptiveScope.',
    );
    return _instance!;
  }

  /// Initializes the global fallback [ScreenConfig].
  ///
  /// Uses [MediaQuery.sizeOf] to avoid unnecessary rebuilds.
  static void init(
    BuildContext context, {
    double designWidth = 375,
    double designHeight = 812,
  }) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    _instance = ScreenConfig(
      designWidth: designWidth,
      designHeight: designHeight,
      screenWidth: size.width,
      screenHeight: size.height,
      safeAreaInsets: padding,
    );
  }

  /// Returns a [ScreenConfig] that actively listens to [MediaQuery] updates.
  ///
  /// Use this along with [AdaptiveScope] to auto-rebuild your app on resize:
  /// ```dart
  /// AdaptiveScope(
  ///   config: ScreenConfig.watch(context),
  ///   child: const MyApp(),
  /// )
  /// ```
  static ScreenConfig watch(
    BuildContext context, {
    double designWidth = 375,
    double designHeight = 812,
  }) {
    final mq = MediaQuery.of(context);
    return ScreenConfig(
      designWidth: designWidth,
      designHeight: designHeight,
      screenWidth: mq.size.width,
      screenHeight: mq.size.height,
      safeAreaInsets: mq.padding,
    );
  }

  /// Returns `true` if the global config has been initialized.
  static bool get isInitialized => _instance != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenConfig &&
          runtimeType == other.runtimeType &&
          designWidth == other.designWidth &&
          designHeight == other.designHeight &&
          screenWidth == other.screenWidth &&
          screenHeight == other.screenHeight &&
          safeAreaInsets == other.safeAreaInsets;

  @override
  int get hashCode => Object.hash(
        designWidth,
        designHeight,
        screenWidth,
        screenHeight,
        safeAreaInsets,
      );
}
