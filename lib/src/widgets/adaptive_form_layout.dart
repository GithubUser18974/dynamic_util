import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// A responsive form row that stacks elements vertically on mobile and laterally on desktop.
///
/// Use this inside forms to optimize space and readability across devices.
///
/// On small screens:
/// [label]
/// [input]
///
/// On large screens:
/// [label]   [input]
class AdaptiveFormRow extends StatelessWidget {
  /// The label widget (e.g., a Text).
  final Widget label;

  /// The input widget (e.g., a TextField).
  final Widget input;

  /// Additional spacing between label and input on mobile. Defaults to 8.0.
  final double mobileSpacing;

  /// Horizontal padding/spacing between label and input on desktop. Defaults to 16.0.
  final double desktopSpacing;

  /// CrossAxisAlignment for the desktop row and mobile column.
  final CrossAxisAlignment crossAxisAlignment;

  /// The flex factor for the label on desktop. Defaults to 1.
  final int labelFlex;

  /// The flex factor for the input on desktop. Defaults to 2.
  final int inputFlex;

  /// The breakpoint width at which the view switches from stacked (Column)
  /// to row (Row). Defaults to [BreakpointConfig.mediumMin] (600.0).
  final double? breakpoint;

  const AdaptiveFormRow({
    super.key,
    required this.label,
    required this.input,
    this.mobileSpacing = 8.0,
    this.desktopSpacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.labelFlex = 1,
    this.inputFlex = 2,
    this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final switchBreakpoint =
        breakpoint ?? const BreakpointConfig.material3().smallMax;

    if (screenWidth >= switchBreakpoint) {
      // Desktop / Tablet layout
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Expanded(
            flex: labelFlex,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: label,
            ),
          ),
          SizedBox(width: desktopSpacing),
          Expanded(
            flex: inputFlex,
            child: input,
          ),
        ],
      );
    } else {
      // Mobile layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          SizedBox(height: mobileSpacing),
          input,
        ],
      );
    }
  }
}
