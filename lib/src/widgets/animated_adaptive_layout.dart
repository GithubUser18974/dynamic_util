import 'package:flutter/widgets.dart';

import 'adaptive_layout.dart';

/// A version of [AdaptiveLayout] that smoothly animates transitions
/// between breakpoint-driven children.
///
/// Under the hood, it uses an [AnimatedSwitcher].
///
/// ```dart
/// AnimatedAdaptiveLayout(
///   duration: Duration(milliseconds: 300),
///   mobile: MobileView(),
///   tablet: TabletView(),
///   desktop: DesktopView(),
/// )
/// ```
class AnimatedAdaptiveLayout extends AdaptiveLayout {
  /// The duration of the transition animation.
  final Duration duration;

  /// The curve used for the switch-in animation.
  final Curve switchInCurve;

  /// The curve used for the switch-out animation.
  final Curve switchOutCurve;

  /// A function that builds the transition between children.
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// Creates an [AnimatedAdaptiveLayout].
  const AnimatedAdaptiveLayout({
    super.key,
    required super.mobile,
    super.mobileLandscape,
    super.tablet,
    super.tabletLandscape,
    super.desktop,
    super.desktopLandscape,
    super.breakpoints,
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final child = resolve(constraints);

        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: switchInCurve,
          switchOutCurve: switchOutCurve,
          transitionBuilder: transitionBuilder,
          child: child,
        );
      },
    );
  }
}
