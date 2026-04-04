## 0.2.0

* **Reactive Architecture Overhaul**: Transitioned from a strict singleton model to a fully reactive `InheritedWidget` system (`AdaptiveScope`). Layouts now safely and automatically respond to window resizing natively.
* **Orientation & SafeArea Additions**: Added `safeScreenHeight` and `isLandscape`/`isPortrait` integrations securely avoiding notches and layout occlusions natively.
* **Component Widgets (`AdaptiveGrid`, `AdaptiveNavigationScaffold`, `showAdaptiveModal`, `AdaptiveWrap`, `AdaptiveImage`)**: Expanded widget toolkit handling layout logic conversions gracefully between desktop monitors and native mobile spaces automatically.
* **Dynamic Property Resolution**: Introduced `AdaptiveValue<T>` allowing robust scaling and conditional assignment of tokens (Colors, Values, Strings) corresponding to screen footprint sizes. Included built-in presets for tailored configurations: Material 3, Tailwind CSS, Bootstrap 5.
* **Scaling Context Utilities**: `context.w(10)`, `context.h(10)`, `context.sp(10)` extensions added to allow seamless and reactive sizing avoiding potential `ScreenConfig.instance` exceptions in deeper trees.
* **Theme Support (`AdaptiveTheme`)**: Effortlessly synchronize typography scopes automatically mapping them across `ThemeData` natively.
* **Development HUD (`AdaptiveDebugOverlay`)**: Shipped an overlay to visually test configurations mapping layout metrics efficiently.
* **Backward Compatible**: Existing static implementations of `ScreenConfig.instance` and generic layout elements will not crash and compile strictly successfully.

## 0.1.0

* Initial release.
* Core setup for dynamic layout extensions natively mapping `.w`, `.h`, `.sp`.
* Included legacy `AdaptiveContainer`, `AdaptivePadding` mechanisms.
