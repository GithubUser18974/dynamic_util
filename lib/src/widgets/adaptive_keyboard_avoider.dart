import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// An adaptive wrapper that automatically pads its child to avoid the software keyboard.
///
/// While [Scaffold.resizeToAvoidBottomInset] usually handles this globally,
/// there are many cases where you want `resizeToAvoidBottomInset: false`
/// (to prevent the whole background from shrinking) and instead want to push up
/// a specific localized widget or scrollable area.
///
/// This widget intelligently applies `MediaQuery.viewInsets.bottom` as padding
/// *only* on mobile breakpoints. On Desktop/Web breakpoints, it assumes physical
/// keyboards or floating OS keyboards and bypasses the padding to prevent layout jumping.
class AdaptiveKeyboardAvoider extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Additional padding to add to the bottom when the keyboard is open.
  /// Useful to provide breathing room above the keyboard. Defaults to 0.0.
  final double extraPadding;

  /// The breakpoint width at which the view switches from applying keyboard padding (Mobile)
  /// to bypassing it (Desktop). Defaults to [BreakpointConfig.mediumMin] (600.0).
  final double? breakpoint;

  /// Creates an [AdaptiveKeyboardAvoider].
  const AdaptiveKeyboardAvoider({
    super.key,
    required this.child,
    this.extraPadding = 0.0,
    this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final switchBreakpoint =
        breakpoint ?? const BreakpointConfig.material3().smallMax;

    final isDesktop = screenWidth >= switchBreakpoint;

    if (isDesktop) {
      // Desktop/Web apps generally don't have screen-intruding software keyboards.
      return child;
    } else {
      // Mobile apps need to push content above the software keyboard.
      final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

      // Only apply extra padding if the keyboard is actually visible.
      final appliedPadding = bottomInset > 0 ? bottomInset + extraPadding : 0.0;

      return Padding(
        padding: EdgeInsets.only(bottom: appliedPadding),
        child: child,
      );
    }
  }
}
