import 'package:flutter/material.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool _maxContentWidthEnabled = false;

  void _toggleMaxWidth(bool value) {
    setState(() => _maxContentWidthEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize global config for static .w/.h usage, but also use
    // AdaptiveScope below for fully reactive widget-tree resizing!
    ScreenConfig.init(context, designWidth: 375, designHeight: 812);

    // 1. Wrap your app in AdaptiveScope for reactive resizing
    return AdaptiveScope(
      config: ScreenConfig.watch(context),
      // NEW: Demonstrate maxContentWidth clamping
      maxContentWidth: _maxContentWidthEnabled ? 800 : null,
      child: Builder(
        builder: (context) {
          final baseLight = ThemeData(
            colorSchemeSeed: const Color(0xFF6C5CE7),
            useMaterial3: true,
            brightness: Brightness.light,
          );
          final baseDark = ThemeData(
            colorSchemeSeed: const Color(0xFF6C5CE7),
            useMaterial3: true,
            brightness: Brightness.dark,
          );

          return MaterialApp(
            title: 'dynamic_layouts Example',
            debugShowCheckedModeBanner: false,
            // 2. Add the Debug Overlay
            builder: (context, child) => AdaptiveDebugOverlay(child: child!),
            // 3. Scale the theme automatically
            theme: AdaptiveTheme.scale(context, base: baseLight),
            darkTheme: AdaptiveTheme.scale(context, base: baseDark),
            themeMode: ThemeMode.system,
            home: MainScreen(
              isMaxWidthEnabled: _maxContentWidthEnabled,
              onToggleMaxWidth: _toggleMaxWidth,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main Screen — tab navigation
// ---------------------------------------------------------------------------
class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.isMaxWidthEnabled,
    required this.onToggleMaxWidth,
  });

  final bool isMaxWidthEnabled;
  final ValueChanged<bool> onToggleMaxWidth;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final _pages = <Widget>[
    const OverviewPage(),
    const LayoutDemoPage(),
    const CollectionDemoPage(),
    const TextDemoPage(),
    const ComponentsDemoPage(),
    AdvancedDemoPage(
      isMaxWidthEnabled: widget.isMaxWidthEnabled,
      onToggleMaxWidth: widget.onToggleMaxWidth,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // We NO LONGER need ScreenConfig.init(context) here because we are
    // using AdaptiveScope at the root of our app!

    // AdaptiveNavigationScaffold auto-switches between BottomNavigationBar
    // and NavigationRail depending on screen width.
    return AdaptiveNavigationScaffold(
      selectedIndex: _currentIndex,
      onDestinationSelected: (i) => setState(() => _currentIndex = i),
      destinations: const [
        AdaptiveNavigationDestination(
          icon: Icon(Icons.dashboard),
          label: 'Overview',
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.view_quilt),
          label: 'Layout',
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.grid_view),
          label: 'Collection',
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.text_fields),
          label: 'Text',
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.widgets),
          label: 'Widgets',
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.auto_fix_high),
          label: 'Advanced',
        ),
      ],
      body: _pages[_currentIndex],
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Overview: Screen info + extension demo
// ---------------------------------------------------------------------------
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final config = ScreenConfig.instance;
    final bp = BreakpointHelper.current(config.screenWidth);

    return Scaffold(
      appBar: AppBar(title: const Text('Overview'), centerTitle: true),
      body: SingleChildScrollView(
        child: AdaptivePadding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Screen Info Card ---
              _SectionTitle('Screen Information', cs),
              const SizedBox(height: 8),
              AdaptiveContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 16,
                color: cs.surfaceContainerHighest,
                child: Column(
                  children: [
                    _InfoRow(
                      'Screen Width',
                      '${config.screenWidth.toStringAsFixed(1)} px',
                      cs,
                    ),
                    _InfoRow(
                      'Screen Height',
                      '${config.screenHeight.toStringAsFixed(1)} px',
                      cs,
                    ),
                    const Divider(),
                    _InfoRow(
                      'Scale Width',
                      config.scaleWidth.toStringAsFixed(3),
                      cs,
                    ),
                    _InfoRow(
                      'Scale Height',
                      config.scaleHeight.toStringAsFixed(3),
                      cs,
                    ),
                    _InfoRow(
                      'Scale Text',
                      config.scaleText.toStringAsFixed(3),
                      cs,
                    ),
                    const Divider(),
                    _InfoRow('Breakpoint', bp.name.toUpperCase(), cs),
                    _InfoRow(
                      'isMobile',
                      '${BreakpointHelper.isMobile(config.screenWidth)}',
                      cs,
                    ),
                    _InfoRow(
                      'isTablet',
                      '${BreakpointHelper.isTablet(config.screenWidth)}',
                      cs,
                    ),
                    _InfoRow(
                      'isDesktop',
                      '${BreakpointHelper.isDesktop(config.screenWidth)}',
                      cs,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Extension Demo ---
              _SectionTitle('Extension Demo (.w / .h / .sp)', cs),
              const SizedBox(height: 8),
              _ExtensionDemoBox(cs: cs, widthVal: 300, heightVal: 60),
              const SizedBox(height: 12),
              _ExtensionDemoBox(cs: cs, widthVal: 200, heightVal: 80),
              const SizedBox(height: 12),
              _ExtensionDemoBox(cs: cs, widthVal: 150, heightVal: 40),
              const SizedBox(height: 24),

              // --- Adaptive helpers ---
              _SectionTitle('Adaptive Helpers', cs),
              const SizedBox(height: 8),
              AdaptiveContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 16,
                color: cs.primaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AdaptiveContainer',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    AdaptiveSizedBox(height: 8),
                    Text(
                      'This container scales its padding, margin, and '
                      'border radius automatically based on device size.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AdaptiveContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 12,
                      color: cs.secondaryContainer,
                      height: 80,
                      child: Center(
                        child: Text(
                          'AdaptiveSizedBox\n& Padding',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AdaptiveSizedBox(width: 12),
                  Expanded(
                    child: AdaptiveContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 12,
                      color: cs.tertiaryContainer,
                      height: 80,
                      child: Center(
                        child: Text(
                          'All scaled\nautomatically',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — AdaptiveLayout demo
// ---------------------------------------------------------------------------
class LayoutDemoPage extends StatelessWidget {
  const LayoutDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('AdaptiveLayout'), centerTitle: true),
      body: AdaptivePadding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle('Resize to see layout switch', cs),
            const SizedBox(height: 12),
            Expanded(
              child: AdaptiveLayout(
                mobile: _LayoutVariant(
                  icon: Icons.phone_android,
                  label: '📱 Mobile Layout',
                  subtitle: 'Single column, compact spacing',
                  color: cs.primaryContainer,
                  textColor: cs.onPrimaryContainer,
                ),
                tablet: _LayoutVariant(
                  icon: Icons.tablet_mac,
                  label: '📋 Tablet Layout',
                  subtitle: 'Two-column grid, medium spacing',
                  color: cs.secondaryContainer,
                  textColor: cs.onSecondaryContainer,
                ),
                desktop: _LayoutVariant(
                  icon: Icons.desktop_mac,
                  label: '🖥️ Desktop Layout',
                  subtitle: 'Multi-column, wide spacing',
                  color: cs.tertiaryContainer,
                  textColor: cs.onTertiaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AdaptiveContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 12,
              color: cs.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Breakpoint Thresholds',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ThresholdRow('Mobile', '< 600 px', cs.primary, cs),
                  _ThresholdRow('Tablet', '600 – 1024 px', cs.secondary, cs),
                  _ThresholdRow('Desktop', '> 1024 px', cs.tertiary, cs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — AdaptiveCollectionView demo
// ---------------------------------------------------------------------------
class CollectionDemoPage extends StatelessWidget {
  const CollectionDemoPage({super.key});

  static const _colors = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFFF7675),
    Color(0xFFFDAA5E),
    Color(0xFF74B9FF),
    Color(0xFFE17055),
    Color(0xFFA29BFE),
    Color(0xFF55EFC4),
    Color(0xFFFF6B81),
    Color(0xFFFFD93D),
    Color(0xFF0984E3),
    Color(0xFFD63031),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AdaptiveCollectionView'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdaptivePadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('List ↔ Grid (auto switch)', cs),
                const SizedBox(height: 4),
                Text(
                  'Small screens → ListView  •  Medium/Large → GridView',
                  style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Expanded(
            child: AdaptiveCollectionView(
              itemCount: 12,
              gridSpacing: 12,
              listSpacing: 10,
              childAspectRatio: 1.3,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemBuilder: (context, index) {
                final color = _colors[index % _colors.length];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withAlpha(180)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.w),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(60),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Item ${index + 1}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 4 — AdaptiveText demo
// ---------------------------------------------------------------------------
class TextDemoPage extends StatelessWidget {
  const TextDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('AdaptiveText'), centerTitle: true),
      body: SingleChildScrollView(
        child: AdaptivePadding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle('Scaled Font Sizes', cs),
              const SizedBox(height: 12),
              ..._buildFontSamples(cs),
              const SizedBox(height: 24),

              _SectionTitle('Max Scale Factor Clamping', cs),
              const SizedBox(height: 12),
              AdaptiveContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 16,
                color: cs.surfaceContainerHighest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AdaptiveText(
                      'maxScaleFactor: 1.0 (no scaling up)',
                      baseFontSize: 16,
                      maxScaleFactor: 1.0,
                    ),
                    AdaptiveSizedBox(height: 12),
                    const AdaptiveText(
                      'maxScaleFactor: 1.5',
                      baseFontSize: 16,
                      maxScaleFactor: 1.5,
                    ),
                    AdaptiveSizedBox(height: 12),
                    const AdaptiveText(
                      'maxScaleFactor: 2.0 (default)',
                      baseFontSize: 16,
                      maxScaleFactor: 2.0,
                    ),
                    AdaptiveSizedBox(height: 12),
                    const AdaptiveText(
                      'maxScaleFactor: 3.0',
                      baseFontSize: 16,
                      maxScaleFactor: 3.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _SectionTitle('System Scaling Control', cs),
              const SizedBox(height: 12),
              AdaptiveContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 16,
                color: cs.secondaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'respectSystemScaling: true (default)',
                      baseFontSize: 14,
                      respectSystemScaling: true,
                      style: TextStyle(color: cs.onSecondaryContainer),
                    ),
                    AdaptiveSizedBox(height: 12),
                    AdaptiveText(
                      'respectSystemScaling: false',
                      baseFontSize: 14,
                      respectSystemScaling: false,
                      style: TextStyle(color: cs.onSecondaryContainer),
                    ),
                    AdaptiveSizedBox(height: 12),
                    Text(
                      'When false, system text scaling is ignored.\n'
                      'Useful for UI labels that must stay fixed.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: cs.onSecondaryContainer.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFontSamples(ColorScheme cs) {
    final sizes = [10.0, 14.0, 18.0, 24.0, 32.0, 42.0];
    return sizes.map((size) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: AdaptiveContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          color: cs.surfaceContainerHighest,
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  '${size.toInt()} sp',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ),
              Expanded(
                child: AdaptiveText(
                  'The quick brown fox',
                  baseFontSize: size,
                  style: TextStyle(color: cs.onSurface),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ===========================================================================
// Shared helper widgets
// ===========================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, this.cs);
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return AdaptiveText(
      text,
      baseFontSize: 22,
      style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, this.cs);
  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtensionDemoBox extends StatelessWidget {
  const _ExtensionDemoBox({
    required this.cs,
    required this.widthVal,
    required this.heightVal,
  });
  final ColorScheme cs;
  final double widthVal;
  final double heightVal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthVal.w,
      height: heightVal.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
        borderRadius: BorderRadius.circular(12.w),
      ),
      alignment: Alignment.center,
      child: Text(
        '${widthVal.toInt()}.w × ${heightVal.toInt()}.h',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: cs.onPrimary,
        ),
      ),
    );
  }
}

class _LayoutVariant extends StatelessWidget {
  const _LayoutVariant({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.textColor,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AdaptiveContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 24,
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48.sp, color: textColor),
            AdaptiveSizedBox(height: 16),
            AdaptiveText(
              label,
              baseFontSize: 24,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            AdaptiveSizedBox(height: 8),
            AdaptiveText(
              subtitle,
              baseFontSize: 14,
              style: TextStyle(color: textColor.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThresholdRow extends StatelessWidget {
  const _ThresholdRow(this.label, this.range, this.dotColor, this.cs);
  final String label;
  final String range;
  final Color dotColor;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            '$label  ',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          Text(
            range,
            style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 5 — Components (AdaptiveWrap, Spacing, Modal, Image, Value)
// ---------------------------------------------------------------------------
class ComponentsDemoPage extends StatelessWidget {
  const ComponentsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // 1. AdaptiveValue demo
    final columnsCount = AdaptiveValue<int>(
      mobile: 1,
      tablet: 2,
      desktop: 3,
    ).resolve(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Components'), centerTitle: true),
      body: SingleChildScrollView(
        child: AdaptivePadding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle('AdaptiveValue<int>', cs),
              Text('Columns count: $columnsCount (resolves differently per breakpoint)'),
              const AdaptiveSpacing(16),

              _SectionTitle('AdaptiveWrap & AdaptiveSpacing', cs),
              AdaptiveContainer(
                padding: const EdgeInsets.all(16),
                color: cs.surfaceContainerHighest,
                borderRadius: 12,
                child: AdaptiveWrap(
                  spacing: context.w(10), // Use context.w for responsive gap
                  children: [
                    _ColoredBox('Item 1', cs.primaryContainer, cs.onPrimaryContainer),
                    _ColoredBox('Item 2', cs.secondaryContainer, cs.onSecondaryContainer),
                    _ColoredBox('Item 3', cs.tertiaryContainer, cs.onTertiaryContainer),
                  ],
                ),
              ),
              const AdaptiveSpacing(24), // Notice no height/width needed!

              _SectionTitle('showAdaptiveModal', cs),
              ElevatedButton(
                onPressed: () {
                  showAdaptiveModal(
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 64, color: cs.primary),
                          const AdaptiveSpacing(16),
                          Text(
                            'Responsive Modal!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const AdaptiveSpacing(8),
                          const Text('BottomSheet on Mobile, Dialog on Desktop.'),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Click me!'),
              ),
              const AdaptiveSpacing(24),

              _SectionTitle('AdaptiveImage', cs),
              const Text('Loads different assets based on breakpoints to save bandwidth.'),
              const AdaptiveSpacing(8),
              AdaptiveContainer(
                height: 150,
                color: cs.onInverseSurface,
                borderRadius: 12,
                child: const AdaptiveImage(
                  mobile: NetworkImage('https://via.placeholder.com/300x150.png?text=Mobile+Image'),
                  tablet: NetworkImage('https://via.placeholder.com/600x150.png?text=Tablet+Image'),
                  desktop: NetworkImage('https://via.placeholder.com/1200x150.png?text=Desktop+Image'),
                  fit: BoxFit.cover,
                ),
              ),
              const AdaptiveSpacing(24),

              _SectionTitle('AdaptiveGrid', cs),
              const Text('Auto-calculates columns: 1 (Mobile), 2 (Tablet), 4 (Desktop)'),
              const AdaptiveSpacing(8),
              AdaptiveContainer(
                height: 300,
                borderRadius: 12,
                color: cs.surfaceContainerHighest,
                child: AdaptiveGrid(
                  itemCount: 12,
                  crossAxisCount: const AdaptiveValue<int>(
                    mobile: 1,
                    tablet: 2,
                    desktop: 4,
                  ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: cs.primary.withAlpha(200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Item ${index + 1}',
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColoredBox extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _ColoredBox(this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(16)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 6 — Advanced (AnimatedLayout, MaxWidth, ScaleBasis)
// ---------------------------------------------------------------------------
class AdvancedDemoPage extends StatelessWidget {
  const AdvancedDemoPage({
    super.key,
    required this.isMaxWidthEnabled,
    required this.onToggleMaxWidth,
  });

  final bool isMaxWidthEnabled;
  final ValueChanged<bool> onToggleMaxWidth;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Layouts'), centerTitle: true),
      body: SingleChildScrollView(
        child: AdaptivePadding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle('Global Width Clamping', cs),
              const Text(
                'Prevent your UI from stretching excessively on ultra-wide screens '
                'by setting a maximum content width in AdaptiveScope.',
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Enable Max Width (800px)'),
                value: isMaxWidthEnabled,
                onChanged: onToggleMaxWidth,
                tileColor: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              const AdaptiveSpacing(24),

              _SectionTitle('AnimatedAdaptiveLayout', cs),
              const Text(
                'Smooth transitions when crossing breakpoints. Try resizing '
                'your browser or switching landscape/portrait.',
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: AnimatedAdaptiveLayout(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOutBack,
                  mobile: _InfoBox('Mobile View', cs.primaryContainer, cs.onPrimaryContainer),
                  tablet: _InfoBox('Tablet View', cs.secondaryContainer, cs.onSecondaryContainer),
                  desktop: _InfoBox('Desktop View', cs.tertiaryContainer, cs.onTertiaryContainer),
                ),
              ),
              const AdaptiveSpacing(24),

              _SectionTitle('Auto-Calculating Grid', cs),
              const Text(
                'Instead of fixed column counts, use maxColumnWidth to let the '
                'grid automatically fill the available space.',
              ),
              const SizedBox(height: 8),
              AdaptiveContainer(
                height: 300,
                color: cs.surfaceContainerHighest,
                borderRadius: 12,
                child: AdaptiveGrid(
                  itemCount: 20,
                  maxColumnWidth: 150, // Auto-column calculation!
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: cs.secondary.withAlpha(150),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox(this.label, this.bg, this.fg);
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(label), // Important for AnimatedSwitcher to detect change
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: fg),
        ),
      ),
    );
  }
}

