import 'package:flutter/widgets.dart';

import '../core/adaptive_scope.dart';
import '../core/breakpoints.dart';

/// A development utility that overlays an information panel displaying the
/// current screen size, scaling factors, orientation, and active breakpoint.
///
/// Simply wrap your app or material app builder to enable it during development:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => AdaptiveDebugOverlay(child: child!),
///   // it will automatically hide if [isEnabled] is false, making it safe
///   // to leave in code with `isEnabled: kDebugMode`.
/// )
/// ```
class AdaptiveDebugOverlay extends StatelessWidget {
  /// The application to wrap.
  final Widget child;

  /// Whether the overlay is visible. Defaults to `true`.
  final bool isEnabled;

  /// Creates an [AdaptiveDebugOverlay].
  const AdaptiveDebugOverlay({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) return child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          const Positioned(
            bottom: 40,
            right: 16,
            child: SafeArea(
              child: IgnorePointer(
                child: _DebugPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugPanel extends StatelessWidget {
  const _DebugPanel();

  @override
  Widget build(BuildContext context) {
    final config = AdaptiveScope.maybeOf(context);
    if (config == null) return const SizedBox.shrink();

    final width = config.screenWidth;
    final bp = BreakpointHelper.current(width);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xCC000000), // ~80% black
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow('Size', '${width.toInt()}x${config.screenHeight.toInt()}'),
          _buildRow('Breakpoint', bp.name.toUpperCase()),
          _buildRow(
              'Orientation', config.isLandscape ? 'Landscape' : 'Portrait'),
          _buildRow('Scale W', config.scaleWidth.toStringAsFixed(2)),
          _buildRow('Scale H', config.scaleHeight.toStringAsFixed(2)),
          _buildRow('Scale T', config.scaleText.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 10,
                fontFamily: 'monospace',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00FFCC),
              fontSize: 11,
              fontFamily: 'monospace',
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
