import 'package:flutter/material.dart';

import '../core/adaptive_scope.dart';

/// Utility to create a scaled [ThemeData] based on [AdaptiveScope] factors.
///
/// This applies scaling to typography and icon themes so that your entire app
/// scales its tokens automatically without needing to wrap every single [Text]
/// widget in [AdaptiveText].
///
/// ```dart
/// AdaptiveScope(
///   config: ScreenConfig.watch(context),
///   child: Builder(
///     builder: (context) {
///       return MaterialApp(
///         theme: AdaptiveTheme.scale(
///           context,
///           base: ThemeData(colorSchemeSeed: Colors.blue),
///         ),
///         home: const MyHomePage(),
///       );
///     },
///   ),
/// )
/// ```
class AdaptiveTheme {
  AdaptiveTheme._();

  /// Scales the typography and icon themes of the [base] theme according
  /// to the scaling factors of the nearest [AdaptiveScope].
  static ThemeData scale(BuildContext context, {required ThemeData base}) {
    final config = AdaptiveScope.of(context);
    final textScale = config.scaleText;

    return base.copyWith(
      textTheme: _scaleTextTheme(base.textTheme, textScale),
      primaryTextTheme: _scaleTextTheme(base.primaryTextTheme, textScale),
      iconTheme: base.iconTheme.copyWith(
        size: (base.iconTheme.size ?? 24) * textScale,
      ),
      primaryIconTheme: base.primaryIconTheme.copyWith(
        size: (base.primaryIconTheme.size ?? 24) * textScale,
      ),
    );
  }

  static TextTheme _scaleTextTheme(TextTheme base, double scale) {
    return base.copyWith(
      displayLarge: _scaleStyle(base.displayLarge, scale),
      displayMedium: _scaleStyle(base.displayMedium, scale),
      displaySmall: _scaleStyle(base.displaySmall, scale),
      headlineLarge: _scaleStyle(base.headlineLarge, scale),
      headlineMedium: _scaleStyle(base.headlineMedium, scale),
      headlineSmall: _scaleStyle(base.headlineSmall, scale),
      titleLarge: _scaleStyle(base.titleLarge, scale),
      titleMedium: _scaleStyle(base.titleMedium, scale),
      titleSmall: _scaleStyle(base.titleSmall, scale),
      bodyLarge: _scaleStyle(base.bodyLarge, scale),
      bodyMedium: _scaleStyle(base.bodyMedium, scale),
      bodySmall: _scaleStyle(base.bodySmall, scale),
      labelLarge: _scaleStyle(base.labelLarge, scale),
      labelMedium: _scaleStyle(base.labelMedium, scale),
      labelSmall: _scaleStyle(base.labelSmall, scale),
    );
  }

  static TextStyle? _scaleStyle(TextStyle? style, double scale) {
    if (style == null || style.fontSize == null) return style;
    return style.copyWith(fontSize: style.fontSize! * scale);
  }
}
