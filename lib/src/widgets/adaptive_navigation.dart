import 'package:flutter/material.dart';

import '../utils/adaptive_value.dart';

/// A scaffold that automatically switches its navigation pattern based on the
/// screen breakpoint.
///
/// - Mobile: `NavigationBar` (Bottom)
/// - Tablet: `NavigationRail` (Side, compact)
/// - Desktop: `NavigationRail` (Side, extended) or `Drawer`
///
/// ```dart
/// AdaptiveNavigationScaffold(
///   selectedIndex: _index,
///   onDestinationSelected: (i) => setState(() => _index = i),
///   destinations: [
///     AdaptiveNavigationDestination(icon: Icon(Icons.home), label: 'Home'),
///     AdaptiveNavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
///   ],
///   body: _pages[_index],
/// )
/// ```
class AdaptiveNavigationScaffold extends StatelessWidget {
  /// The currently selected navigation index.
  final int selectedIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// The list of destinations.
  final List<AdaptiveNavigationDestination> destinations;

  /// The main content of the scaffold.
  final Widget body;

  /// Optional app bar.
  final PreferredSizeWidget? appBar;

  /// Whether to use an extended side rail on desktop screens.
  /// Defaults to `true`.
  final bool extendedDesktop;

  /// Creates an [AdaptiveNavigationScaffold].
  const AdaptiveNavigationScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.extendedDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the navigation type based on breakpoint
    final navType = AdaptiveValue<_NavType>(
      mobile: _NavType.bottom,
      tablet: _NavType.railCompact,
      desktop: extendedDesktop ? _NavType.railExtended : _NavType.railCompact,
    ).resolve(context);

    if (navType == _NavType.bottom) {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations.map((d) {
            return NavigationDestination(
              icon: d.icon,
              selectedIcon: d.selectedIcon,
              label: d.label,
            );
          }).toList(),
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              extended: navType == _NavType.railExtended,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon ?? d.icon,
                  label: Text(d.label),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
  }
}

/// A destination configuration for [AdaptiveNavigationScaffold].
class AdaptiveNavigationDestination {
  /// The icon to display.
  final Widget icon;

  /// The optional selected icon.
  final Widget? selectedIcon;

  /// The text label.
  final String label;

  /// Creates an [AdaptiveNavigationDestination].
  const AdaptiveNavigationDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}

enum _NavType { bottom, railCompact, railExtended }
