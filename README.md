# dynamic_layouts

A lightweight, dependency-free Flutter package for building fluid, heavily responsive, adaptive UI rendering across mobile, tablet, and desktop screens natively. 

Built on a modern, strictly reactive `InheritedWidget` architecture (`AdaptiveScope`), it efficiently responds to window resizing, layout transitions, safe-area, and orientation constraints natively.


## ⚡ Setup & Architecture

### 1. Initialize AdaptiveScope
Inject `AdaptiveScope` at the application root passing a continuous `ScreenConfig.watch(context)`. This creates a unified configuration reacting to `MediaQuery` bounds across the entire Flutter ecosystem natively.

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
      child: MaterialApp(
        builder: (context, child) => AdaptiveDebugOverlay(child: child!),
        home: HomeScreen(),
      ),
    );
  }
}
```

### 2. Contextual Dimensional Scaling
Safely extract responsive bounds tailored downwards into the tree. Your fonts, padding, and alignments automatically morph based on constraints tracking physical size vs `designWidth`/`designHeight`.

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
*(**Note:** Global static `.w`, `.h`, `.sp` variables extended on `num` are preserved for backward compatibility if you run `ScreenConfig.init()` strictly).*

---

## 🛠️ Feature & UI Components Matrix

### AdaptiveValue<T>
Avoid `if/else` constraint logic inside builders. Use `AdaptiveValue` to conditionally map configurations directly derived from responsive constraints natively.

```dart
// Auto-resolves based on current screen boundary.
final paddingLimit = const AdaptiveValue<double>(
  mobile: 16.0,
  tablet: 32.0,
  desktop: 64.0,
).resolve(context);

Container(padding: EdgeInsets.all(paddingLimit));
```

### AdaptiveLayout
Return entirely distinct widget blueprints depending on the bounds. Supports native fallback (e.g., if Desktop isn't provided, falls back to Tablet, then to Mobile).

```dart
AdaptiveLayout(
  mobile: MobileHomeView(),
  mobileLandscape: MobileLandscapeView(),
  tablet: TabletHomeView(),
  desktop: DesktopHomeView(),
)
```

### AdaptiveGrid
Automagically scale grid layout matrices utilizing `AdaptiveValue`. Provide a responsive `crossAxisCount` resolving automatically.

```dart
AdaptiveGrid(
  itemCount: 20,
  crossAxisCount: const AdaptiveValue<int>(
    mobile: 1, // 1 column wide on phone
    tablet: 2, // 2 columns wide on standard iPads
    desktop: 4, // 4 columns on native desktops
  ),
  itemBuilder: (context, index) => Card(child: Text('Index $index')),
)
```

### AdaptiveCollectionView
Dynamically shift an axis iteration rendering natively as a `ListView` on tight mobile bounds, but elevating to a `GridView` seamlessly on stretched tablets/desktops.

```dart
AdaptiveCollectionView(
  itemCount: 40,
  listSpacing: 10,
  gridSpacing: 12,
  childAspectRatio: 1.5,
  itemBuilder: (context, index) => ItemTile(index),
)
```

### AdaptiveWrap
Flipping between vertical `Column`s and horizontal `Row`s seamlessly. Renders constraints natively based on a specified breakpoint target.

```dart
AdaptiveWrap(
  spacing: context.w(16),
  // Displays items in a Row above 1024px. Displays in Column on devices smaller.
  rowBreakpoint: BreakpointConfig.material3().largeMin, 
  children: [
    SectionWidgetOne(),
    SectionWidgetTwo(),
  ],
)
```

### AdaptiveSpacing
An invisible gap block scaling natively into either `Row` boundaries (`scaleWidth`) or `Column` enclosures (`scaleHeight`) without having to specify explicitly!

```dart
Row(
  children: [
    Icon(Icons.person),
    AdaptiveSpacing(16), // Automatically becomes SizedBox(width: 16 * scaleWidth)
    Text('Profile'),
  ],
)
```

### AdaptiveNavigationScaffold
An intelligent `Scaffold` eliminating boilerplate. Renders a native `BottomNavigationBar` spanning smaller screens, instantly snapping into a `NavigationRail` or native `Drawer` frame on Desktop limits.

```dart
AdaptiveNavigationScaffold(
  selectedIndex: _index,
  onDestinationSelected: (i) => setState(() => _index = i),
  destinations: [
    AdaptiveNavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    AdaptiveNavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: MainDataView(),
);
```

### AdaptiveImage
Optimize network constraints natively. Fetches varying image definitions depending strictly on pixel footprint logic isolating payload weights natively.

```dart
AdaptiveImage(
  mobile: NetworkImage('https://.../small.png'),
  tablet: NetworkImage('https://.../medium.png'),
  desktop: NetworkImage('https://.../high-res.png'),
)
```

### showAdaptiveModal
Presents layout native models handling Dialog interfaces implicitly. Triggers standard `BottomSheet` tracking on Mobile bounds mutating neatly into floating `Dialog` bounds on desktop views.

```dart
showAdaptiveModal(
  context: context,
  builder: (context) => SettingsModal(),
);
```

### AdaptiveTheme
Interpolates nested `ThemeData` variables scaling typography ranges explicitly mapping them securely across UI systems automatically.

```dart
MaterialApp(
  theme: AdaptiveTheme.scale(
    context, 
    base: ThemeData(colorSchemeSeed: Colors.blue), // Scales displayLarge/bodySmall/Icons natively.
  ),
  home: ApplicationCore(),
)
```

### AdaptiveDebugOverlay
Inject an aggressive graphical bounding box HUD exposing metrics natively for swift responsive deployment.

```dart
MaterialApp(
  builder: (context, child) => AdaptiveDebugOverlay(child: child!),
)
```

---

## ⚙️ Breakpoint Architectures

Built-in tailored presets out-of-the-box corresponding to industry tracking metrics:

```dart
// Native presets internally resolved across features seamlessly
BreakpointConfig.material3();
BreakpointConfig.bootstrap();
BreakpointConfig.tailwind();
```

## License
MIT — see [LICENSE](LICENSE)
