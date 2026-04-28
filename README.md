# dynamic_layouts

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/GithubUser18974/dynamic_util)
[![Pub Version](https://img.shields.io/pub/v/dynamic_layouts)](https://pub.dev/packages/dynamic_layouts)
[![CI](https://github.com/GithubUser18974/dynamic_util/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/GithubUser18974/dynamic_util/actions/workflows/flutter_ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tested](https://img.shields.io/badge/Tested-Widget%20%26%20Unit-brightgreen)](test)

![Dynamic Layouts Hero](doc/assets/hero.png)

A lightweight, dependency-free Flutter package for fluid adaptive UI on mobile, tablet, desktop, and web.

Built on a strictly reactive `InheritedWidget` architecture (`AdaptiveScope`), it responds to resizing, orientation, and safe-area constraints without boilerplate.

---

## What's New (0.4.0)

### 1) Fluid interpolation with `.fluid`
Scale values smoothly between breakpoints instead of jumping at hard cutoffs.

```dart
// BuildContext extension (fully reactive)
final headingSize = context.fluid(24, 40, minWidth: 375, maxWidth: 1024);

// num extension (legacy/global ScreenConfig.instance based)
final cardPadding = 16.fluid(28, minWidth: 375, maxWidth: 1024);
```

### 2) `AdaptiveMasterDetail<T>`
Use split-view on wide screens and stacked navigation on smaller screens, with a single widget.

```dart
AdaptiveMasterDetail<User>(
  masterBuilder: (context, onSelect) => ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, i) => ListTile(
      title: Text(users[i].name),
      onTap: () => onSelect(users[i]),
    ),
  ),
  detailBuilder: (context, selected, {onBack}) {
    if (selected == null) return const Center(child: Text('Select a user'));
    return Scaffold(
      appBar: onBack != null
          ? AppBar(leading: BackButton(onPressed: onBack))
          : null,
      body: UserDetails(user: selected),
    );
  },
)
```

### 3) `AdaptiveFormRow`
Automatically stack fields on small screens and align in rows on larger ones.

```dart
AdaptiveFormRow(
  label: const Text('Email'),
  input: TextFormField(
    decoration: const InputDecoration(hintText: 'name@domain.com'),
  ),
)
```

---

## Adaptive Demos

Experience seamless layout shifts from mobile to desktop.

| Mobile Experience | Tablet & Desktop Experience |
| :---: | :---: |
| <img src="doc/assets/mobile_demo.webp" width="300" alt="Mobile Demo"> | <img src="doc/assets/desktop_demo.webp" width="550" alt="Desktop Demo"> |
| *Bottom Navigation and List Layout* | *Navigation Rail and Grid Layout* |

---

## Setup

### 1) Initialize `AdaptiveScope`
Place `AdaptiveScope` at app root and pass a reactive `ScreenConfig.watch(context)`.

```dart
import 'package:dynamic_layouts/dynamic_layouts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScope(
      config: ScreenConfig.watch(
        context,
        designWidth: 375,
        designHeight: 812,
      ),
      maxContentWidth: 1000, // Optional: clamp ultra-wide content.
      child: MaterialApp(
        builder: (context, child) => AdaptiveDebugOverlay(child: child!),
        home: const HomeScreen(),
      ),
    );
  }
}
```

### 2) Use contextual scaling

```dart
Container(
  width: context.w(200),
  height: context.h(100),
  padding: EdgeInsets.all(context.w(16)),
  child: Text(
    'Responsive Font',
    style: TextStyle(fontSize: context.sp(16)),
  ),
)
```

> [!TIP]
> Legacy static `.w`, `.h`, `.sp` on `num` remain available when initializing `ScreenConfig.init()`.

### 3) Pick your scaling basis

```dart
AdaptiveScope(
  config: ScreenConfig.watch(
    context,
    defaultScaleBasis: ScaleBasis.width,
  ),
  child: const MyApp(),
)
```

---

## Feature Highlights and Usage

### `AdaptiveValue<T>`
Avoid hand-written if/else branches in builders.

```dart
final horizontalPadding = const AdaptiveValue<double>(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 40.0,
).resolve(context);
```

### `AdaptiveLayout` and `AnimatedAdaptiveLayout`
Switch entire widget trees by breakpoint, with optional animated transitions.

```dart
AnimatedAdaptiveLayout(
  duration: const Duration(milliseconds: 350),
  mobile: const MobileView(),
  tablet: const TabletView(),
  desktop: const DesktopView(),
)
```

### `AdaptiveGrid`
Use fixed breakpoints or automatic column calculation from `maxColumnWidth`.

```dart
AdaptiveGrid(
  itemCount: 20,
  maxColumnWidth: 180,
  itemBuilder: (context, index) => Card(child: Center(child: Text('Item $index'))),
)
```

### `AdaptiveNavigationScaffold`
Automatically uses bottom navigation on mobile and rail navigation on larger screens.

```dart
AdaptiveNavigationScaffold(
  selectedIndex: index,
  onDestinationSelected: (i) => setState(() => index = i),
  destinations: const [
    AdaptiveNavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    AdaptiveNavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: pages[index],
)
```

### `AdaptiveCollectionView` and `AdaptiveWrap`
- `AdaptiveCollectionView`: list-like UX on compact widths, grid-like UX on larger layouts.
- `AdaptiveWrap`: switches row/column style layouts at a breakpoint.

---

## Breakpoint Presets

```dart
BreakpointConfig.material3();
BreakpointConfig.bootstrap();
BreakpointConfig.tailwind();
```

---

## ScaleBasis Decision Guide

- `ScaleBasis.width`: best for width-driven designs (marketing pages, fixed horizontal rhythm).
- `ScaleBasis.height`: useful for vertical composition-heavy interfaces (kiosk/fullscreen flows).
- `ScaleBasis.shortestSide`: safest default for cross-device consistency.
- `ScaleBasis.longestSide`: niche choice for large-screen-first layouts.

Start with `shortestSide`, then switch only when design QA shows a clear need.

---

## Migration Guide

### If you already use legacy static scaling

1. Keep existing `num` extensions (`16.w`, `14.sp`) to avoid breakage.
2. Introduce `AdaptiveScope` at root with `ScreenConfig.watch(context)`.
3. Gradually migrate leaf widgets to context-based APIs (`context.w/h/sp`, `context.fluid`).
4. Remove explicit singleton dependencies from deeply nested widgets.

### Recommended end state

- Prefer `AdaptiveScope` + context-based methods for full reactivity.
- Keep static APIs only where needed for legacy or transitional code.

---

## Quality, Testing, and Performance

- CI runs on every change via [GitHub Actions](https://github.com/GithubUser18974/dynamic_util/actions/workflows/flutter_ci.yml).
- Package includes widget and unit tests across core logic and adaptive widgets.
- For local coverage reports:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

- Runtime approach is lightweight and dependency-free; adaptive values are computed from current constraints with minimal overhead.

---

## Why `dynamic_layouts`?

- **Compared to manual `LayoutBuilder` branching:** less repeated breakpoint logic and more reusable adaptive primitives.
- **Compared to scaling-only utilities:** combines scaling, breakpoints, and adaptive widgets in one package.
- **Compared to router-coupled adaptive solutions:** `AdaptiveMasterDetail<T>` supports responsive navigation patterns without requiring a custom routing stack.

---

## License

MIT - see [LICENSE](LICENSE)
