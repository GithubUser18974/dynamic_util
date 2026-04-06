# dynamic_layouts

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/GithubUser18974/dynamic_util)
[![Pub Version](https://img.shields.io/pub/v/dynamic_layouts)](https://pub.dev/packages/dynamic_layouts)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![Dynamic Layouts Hero](doc/assets/hero.png)

A lightweight, dependency-free Flutter package for building fluid, heavily responsive, adaptive UI rendering across mobile, tablet, and desktop screens natively. 

Built on a modern, strictly reactive `InheritedWidget` architecture (`AdaptiveScope`), it efficiently responds to window resizing, layout transitions, safe-area, and orientation constraints natively.

---

## 📱 Adaptive Demos

Experience how the package handles layout shifts from mobile to desktop seamlessly.

| Mobile Experience | Tablet & Desktop Experience |
| :---: | :---: |
| <img src="doc/assets/mobile_demo.webp" width="300" alt="Mobile Demo"> | <img src="doc/assets/desktop_demo.webp" width="550" alt="Desktop Demo"> |
| *Bottom Navigation & List Layout* | *Navigation Rail & Grid Layout* |

---

## ⚡ Setup & Architecture

### 1. Initialize AdaptiveScope
Inject `AdaptiveScope` at the application root passing a continuous `ScreenConfig.watch(context)`. 

> [!IMPORTANT]
> This creates a unified configuration reacting to `MediaQuery` bounds across the entire Flutter ecosystem natively.

```dart
import 'package:dynamic_layouts/dynamic_layouts.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScope(
      config: ScreenConfig.watch(
        context, 
        designWidth: 375, // Your figma/design base width
        designHeight: 812 // Your figma/design base height
      ),
      // NEW: Clamping max width for ultra-wide screens
      maxContentWidth: 1000, 
      child: MaterialApp(
        builder: (context, child) => AdaptiveDebugOverlay(child: child!),
        home: HomeScreen(),
      ),
    );
  }
}
```

### 2. Contextual Dimensional Scaling
Safely extract responsive bounds tailored downwards into the tree. Your fonts, padding, and alignments automatically morph based on constraints.

```dart
Container(
  // Scales 200 physical pixels natively relative to current bounding constraints
  width: context.w(200),    
  height: context.h(100),   
  padding: EdgeInsets.all(context.w(16)),
  child: Text(
    'Responsive Font',
    style: TextStyle(fontSize: context.sp(16)),  // Text scales independently
  ),
)
```

> [!TIP]
> Global static `.w`, `.h`, `.sp` variables extended on `num` are preserved for backward compatibility if you run `ScreenConfig.init()` strictly.

### 3. Scaling Basis
Choose how your dimensions scale. By default, it uses `shortestSide` (similar to `flutter_screenutil`), but you can explicitly scale by `width` or `height` for specialized designs.

```dart
AdaptiveScope(
  config: ScreenConfig.watch(
    context, 
    defaultScaleBasis: ScaleBasis.width // Scale everything purely by width
  ),
  child: MyApp(),
)
```

---

## 🛠️ Feature & UI Components Matrix

### AdaptiveValue<T>
Avoid `if/else` constraint logic inside builders. Use `AdaptiveValue` to conditionally map configurations directly.

```dart
// Auto-resolves based on current screen boundary.
final paddingLimit = const AdaptiveValue<double>(
  mobile: 16.0,
  tablet: 32.0,
  desktop: 64.0,
).resolve(context);
```

### AdaptiveLayout
Return entirely distinct widget blueprints depending on the bounds. Supports native fallback. Use **`AnimatedAdaptiveLayout`** for smooth cross-fades when crossing breakpoints.

### AdaptiveGrid
Automagically scale grid layout matrices.
- **Breakpoint-driven**: Provide a responsive `crossAxisCount` resolving automatically via `AdaptiveValue`.
- **Auto-calculated**: Provide a `maxColumnWidth` to let the grid calculate the columns based on available space.

```dart
AdaptiveGrid(
  itemCount: 20,
  maxColumnWidth: 150, // Auto-column calculation!
  itemBuilder: (context, index) => Card(child: Text('Item $index')),
)
```

### AnimatedAdaptiveLayout
A drop-in replacement for `AdaptiveLayout` that provides smooth cross-fades when crossing breakpoints.

```dart
AnimatedAdaptiveLayout(
  duration: Duration(milliseconds: 500),
  switchInCurve: Curves.easeInOut,
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

### AdaptiveCollectionView
Dynamically shift an axis iteration rendering natively as a `ListView` on tight mobile bounds, but elevating to a `GridView` seamlessly on tablets/desktops.

### AdaptiveWrap
Flipping between vertical `Column`s and horizontal `Row`s seamlessly based on a specified breakpoint target.

### AdaptiveNavigationScaffold
An intelligent `Scaffold` that renders a native `BottomNavigationBar` on smaller screens, instantly snapping into a `NavigationRail` or native `Drawer` on Desktop limits.

---

## ⚙️ Breakpoint Architectures

Built-in tailored presets corresponding to industry tracking metrics:

```dart
BreakpointConfig.material3();
BreakpointConfig.bootstrap();
BreakpointConfig.tailwind();
```

## License
MIT — see [LICENSE](LICENSE)
