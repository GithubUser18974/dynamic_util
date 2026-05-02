import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// A Scaffold that manages a drawer's presentation based on the screen breakpoint.
///
/// - **Mobile**: The drawer acts as a standard Modal drawer hidden behind a menu icon.
/// - **Tablet/Desktop**: The drawer is permanently "docked" as a fixed side-pane next to the body.
///
/// ```dart
/// AdaptiveDrawerScaffold(
///   drawer: MyCustomDrawer(),
///   appBar: AppBar(title: Text('My App')),
///   body: Center(child: Text('Content')),
/// )
/// ```
class AdaptiveDrawerScaffold extends StatelessWidget {
  /// The main content of the scaffold.
  final Widget body;

  /// The drawer to display. Often a [Drawer] or a custom widget.
  final Widget drawer;

  /// An optional app bar. On mobile, a menu icon will be automatically
  /// added if there is a drawer.
  final PreferredSizeWidget? appBar;

  /// Whether the drawer should be docked on Tablet screens.
  /// If false, it will only dock on Desktop screens.
  /// Defaults to true.
  final bool dockOnTablet;

  /// Creates an [AdaptiveDrawerScaffold].
  const AdaptiveDrawerScaffold({
    super.key,
    required this.body,
    required this.drawer,
    this.appBar,
    this.dockOnTablet = true,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve the active breakpoint. We rely on ScreenConfig or BreakpointHelper directly.
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = BreakpointHelper.isDesktop(screenWidth);
    final isTablet = BreakpointHelper.isTablet(screenWidth);

    final shouldDock = isDesktop || (isTablet && dockOnTablet);

    if (shouldDock) {
      // Docked mode: Drawer is permanently visible alongside the body.
      // We don't use the scaffold's native drawer property here.
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            drawer,
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      // Mobile mode: Use standard modal drawer
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: body,
      );
    }
  }
}
