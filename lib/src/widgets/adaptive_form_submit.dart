import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// An adaptive wrapper for form submission buttons.
///
/// - On **Mobile**: Spans the full width of the screen (`double.infinity`), a common
/// pattern to make the primary call-to-action easily accessible for thumbs.
/// - On **Desktop**: Shrinks to fit its content and aligns to the trailing edge (right by default),
/// a common pattern for desktop forms.
class AdaptiveFormSubmit extends StatelessWidget {
  /// The button to display (e.g., [ElevatedButton], [FilledButton]).
  final Widget child;

  /// The alignment of the button on desktop. Defaults to [AlignmentDirectional.centerEnd].
  final AlignmentGeometry desktopAlignment;

  /// The breakpoint width at which the view switches from full-width (Mobile)
  /// to aligned (Desktop). Defaults to [BreakpointConfig.mediumMin] (600.0).
  final double? breakpoint;

  /// Creates an [AdaptiveFormSubmit].
  const AdaptiveFormSubmit({
    super.key,
    required this.child,
    this.desktopAlignment = AlignmentDirectional.centerEnd,
    this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final switchBreakpoint =
        breakpoint ?? const BreakpointConfig.material3().smallMax;

    final isDesktop = screenWidth >= switchBreakpoint;

    if (isDesktop) {
      return Align(
        alignment: desktopAlignment,
        child: child,
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: child,
      );
    }
  }
}
