import 'package:flutter/material.dart';
import 'package:dynamic_util/dynamic_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dynamic_util Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenConfig once at the root.
    ScreenConfig.init(context, designWidth: 375, designHeight: 812);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('dynamic_util Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: AdaptivePadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Section: Screen Info ---
              AdaptiveText(
                'Screen Info',
                baseFontSize: 24,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              AdaptiveSizedBox(height: 8),
              _InfoCard(colorScheme: colorScheme),

              AdaptiveSizedBox(height: 24),

              // --- Section: Adaptive Layout ---
              AdaptiveText(
                'Adaptive Layout',
                baseFontSize: 24,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              AdaptiveSizedBox(height: 8),
              AdaptiveLayout(
                mobile: _LayoutCard(
                  label: '📱 Mobile Layout',
                  color: colorScheme.primaryContainer,
                  textColor: colorScheme.onPrimaryContainer,
                ),
                tablet: _LayoutCard(
                  label: '📋 Tablet Layout',
                  color: colorScheme.secondaryContainer,
                  textColor: colorScheme.onSecondaryContainer,
                ),
                desktop: _LayoutCard(
                  label: '🖥️ Desktop Layout',
                  color: colorScheme.tertiaryContainer,
                  textColor: colorScheme.onTertiaryContainer,
                ),
              ),

              AdaptiveSizedBox(height: 24),

              // --- Section: Adaptive Collection ---
              AdaptiveText(
                'Adaptive Collection (List ↔ Grid)',
                baseFontSize: 24,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              AdaptiveSizedBox(height: 8),
              SizedBox(
                height: 400,
                child: AdaptiveCollectionView(
                  itemCount: 12,
                  gridSpacing: 12,
                  listSpacing: 8,
                  childAspectRatio: 1.4,
                  itemBuilder: (context, index) {
                    return AdaptiveContainer(
                      padding: const EdgeInsets.all(12),
                      borderRadius: 12,
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: AdaptiveText(
                          'Item ${index + 1}',
                          baseFontSize: 16,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              AdaptiveSizedBox(height: 24),

              // --- Section: Scaled Text ---
              AdaptiveText(
                'Adaptive Text Scaling',
                baseFontSize: 24,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              AdaptiveSizedBox(height: 8),
              AdaptiveContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: 12,
                color: colorScheme.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'baseFontSize: 12',
                      baseFontSize: 12,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    AdaptiveSizedBox(height: 4),
                    AdaptiveText(
                      'baseFontSize: 16',
                      baseFontSize: 16,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    AdaptiveSizedBox(height: 4),
                    AdaptiveText(
                      'baseFontSize: 20',
                      baseFontSize: 20,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    AdaptiveSizedBox(height: 4),
                    AdaptiveText(
                      'baseFontSize: 28',
                      baseFontSize: 28,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              AdaptiveSizedBox(height: 24),

              // --- Section: Extension Usage ---
              AdaptiveText(
                'Extension Usage (.w / .h / .sp)',
                baseFontSize: 24,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              AdaptiveSizedBox(height: 8),
              Container(
                width: 300.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                alignment: Alignment.center,
                child: Text(
                  '300.w × 60.h  •  fontSize: 16.sp',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AdaptiveSizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final config = ScreenConfig.instance;
    final bp = BreakpointHelper.current(config.screenWidth);

    return AdaptiveContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Screen Width', '${config.screenWidth.toStringAsFixed(1)} px'),
          _row('Screen Height', '${config.screenHeight.toStringAsFixed(1)} px'),
          _row('Scale Width', config.scaleWidth.toStringAsFixed(3)),
          _row('Scale Height', config.scaleHeight.toStringAsFixed(3)),
          _row('Scale Text', config.scaleText.toStringAsFixed(3)),
          _row('Breakpoint', bp.name.toUpperCase()),
          _row('isMobile', '${BreakpointHelper.isMobile(config.screenWidth)}'),
          _row('isTablet', '${BreakpointHelper.isTablet(config.screenWidth)}'),
          _row(
              'isDesktop', '${BreakpointHelper.isDesktop(config.screenWidth)}'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: colorScheme.onSurfaceVariant)),
          Text(value,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}

class _LayoutCard extends StatelessWidget {
  const _LayoutCard({
    required this.label,
    required this.color,
    required this.textColor,
  });
  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AdaptiveContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      borderRadius: 16,
      color: color,
      child: Center(
        child: AdaptiveText(
          label,
          baseFontSize: 20,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
