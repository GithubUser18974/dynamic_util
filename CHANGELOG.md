## 0.6.1 - 2026-05-06

* **Docs**: Added social contact links to `README.md`.

## 0.6.0 - 2026-05-03

* **Advanced Form Additions**: Introduced `AdaptiveTextField` and `AdaptiveFormSubmit`.
  * `AdaptiveTextField` automatically adjusts its internal `InputDecoration` to be spacious on mobile (for better touch targets) and compact on desktop (`isDense = true`).
  * `AdaptiveFormSubmit` intelligently spans the full width of the screen on mobile, while shrinking and aligning to the trailing edge on desktop forms.

## 0.5.0 - 2026-05-02

* **Advanced Desktop Scaffolding**: Introduced `AdaptiveDrawerScaffold`. This scaffold intelligently places a drawer based on screen size: it acts as a standard modal drawer on mobile, and becomes a permanently docked side pane on tablet/desktop.
* **Adaptive Slivers**: Added `AdaptiveSliverGrid`, a sliver equivalent of `AdaptiveGrid` that automatically adjusts its `crossAxisCount` based on breakpoints or `maxColumnWidth`, perfect for `CustomScrollView` implementations.

## 0.4.2 - 2026-04-28
* Update Readme 
* Add pubspec.yaml

## 0.4.1 - 2026-04-28
* Update Readme 
* Add pubspec.yaml

## 0.4.0 - 2026-04-20

* **Fluid Scaling**: Introduced `.fluid(min, max)` extension on both `num` and `BuildContext`. This allows seamless interpolation of sizes (like padding and text) between defined width breakpoints, eliminating jarring jumps in UI scaling.
* **Adaptive Master-Detail**: Added `AdaptiveMasterDetail<T>`, a robust widget that handles split-view logic on wide screens and stateful layered navigation on small screens automatically, without enforcing a hard dependency on custom app routers.
* **Responsive Forms**: Introduced `AdaptiveFormRow`, which cleanly stacks forms vertically on mobile devices while spreading them laterally into responsive grid alignments on desktops.

## 0.3.0 - 2026-04-06

* **Animated Layouts**: Introduced `AnimatedAdaptiveLayout`, a drop-in replacement for `AdaptiveLayout` that smoothly cross-fades between widgets when crossing breakpoints. Perfect for Desktop/Web resizing.
* **Global Width Clamping**: Added `maxContentWidth` to `AdaptiveScope`. Easily prevent your UI from stretching excessively on Ultra-wide monitors by centered-constraining the entire app content.
* **Automatic Grid Calculation**: `AdaptiveGrid` now supports `maxColumnWidth`. Instead of fixed columns, the grid can automatically calculate how many items fit based on their desired width.
* **Flexible Scaling Basis**: `ScreenConfig` now supports `ScaleBasis` (Width, Height, ShortestSide, LongestSide). Choose exactly how your `context.w/h/sp` scales relative to your design.
* **Advanced Example Demo**: Added a new "Advanced" navigation tab to the example app to demonstrate these new capabilities in real-time.

## 0.2.2 - 2026-04-04

* **Premium Visuals & Demos**: Massive update to `README.md` with a hero image and adaptive WebP recordings demonstrating mobile/desktop layout shifts.
* **Documentation Assets**: Organized assets into the `doc/assets` directory for improved package distribution.

## 0.2.1 - 2026-04-04

* **Metadata Fix**: Updated homepage and repository URLs in `pubspec.yaml` to point to the correct GitHub repository.

## 0.2.0 - 2026-04-04

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
