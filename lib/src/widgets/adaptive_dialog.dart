import 'package:flutter/material.dart';

import '../utils/adaptive_value.dart';

/// Shows a responsive dialog that adapts to the current screen size.
///
/// On small screens (mobile), it appears as a modal bottom sheet.
/// On medium and large screens (tablet, desktop), it appears as a centered dialog.
///
/// ```dart
/// showAdaptiveModal<String>(
///   context: context,
///   builder: (context) => const Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Hello!'),
///   ),
/// );
/// ```
Future<T?> showAdaptiveModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  Color? barrierColor,
  bool isDismissible = true,
  double desktopMaxWidth = 500,
}) {
  final useBottomSheet = AdaptiveValue<bool>(
    mobile: true,
    tablet: false,
    desktop: false,
  ).resolve(context);

  if (useBottomSheet) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
      isScrollControlled:
          true, // allows it to size to content instead of half screen
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  } else {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      barrierDismissible: isDismissible,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktopMaxWidth),
            child: builder(dialogContext),
          ),
        );
      },
    );
  }
}
