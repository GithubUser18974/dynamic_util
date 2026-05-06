import 'package:flutter/material.dart';

import '../core/breakpoints.dart';

/// An adaptive wrapper around [TextField] / [TextFormField] that automatically
/// adjusts its layout density based on the screen size.
///
/// On mobile (touch devices), it uses a spacious layout for easier tapping.
/// On desktop (pointer devices), it uses a compact layout (`isDense = true`)
/// to match standard desktop form design.
class AdaptiveTextField extends StatelessWidget {
  /// The breakpoint width at which the view switches from spacious (Mobile)
  /// to dense (Desktop). Defaults to [BreakpointConfig.mediumMin] (600.0).
  final double? breakpoint;

  /// Whether this is a [TextFormField] or a standard [TextField].
  final bool isFormField;

  /// The standard properties for the internal text field.
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  /// Creates an adaptive [TextField].
  const AdaptiveTextField({
    super.key,
    this.breakpoint,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  })  : isFormField = false,
        validator = null;

  /// Creates an adaptive [TextFormField].
  const AdaptiveTextField.form({
    super.key,
    this.breakpoint,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  }) : isFormField = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final switchBreakpoint =
        breakpoint ?? const BreakpointConfig.material3().smallMax;

    final isDesktop = screenWidth >= switchBreakpoint;

    // Resolve the decoration with adaptive density
    InputDecoration effectiveDecoration = (decoration ?? const InputDecoration()).copyWith(
      isDense: isDesktop,
      contentPadding: isDesktop
          ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0)
          : const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    );

    if (isFormField) {
      return TextFormField(
        controller: controller,
        decoration: effectiveDecoration,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
      );
    } else {
      return TextField(
        controller: controller,
        decoration: effectiveDecoration,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      );
    }
  }
}
