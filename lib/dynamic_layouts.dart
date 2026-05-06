/// A lightweight, dependency-free Flutter package for adaptive UI rendering
/// across mobile, tablet, and desktop screens.
///
/// ## Quick Start
///
/// 1. Initialize in your root widget:
/// ```dart
/// ScreenConfig.init(context, designWidth: 375, designHeight: 812);
/// ```
///
/// 2. Use adaptive sizing:
/// ```dart
/// Container(width: 200.w, height: 100.h)
/// Text('Hello', style: TextStyle(fontSize: 16.sp))
/// ```
///
/// 3. Use adaptive widgets:
/// ```dart
/// AdaptiveLayout(
///   mobile: MobileView(),
///   tablet: TabletView(),
///   desktop: DesktopView(),
/// )
/// ```
library;

// Core
export 'src/core/adaptive_scope.dart';
export 'src/core/screen_config.dart';
export 'src/core/breakpoints.dart';

// Utils
export 'src/utils/adaptive_theme.dart';
export 'src/utils/adaptive_value.dart';
export 'src/utils/size_extensions.dart';

// Widgets
export 'src/widgets/adaptive_collection_view.dart';
export 'src/widgets/adaptive_container.dart';
export 'src/widgets/adaptive_debug_overlay.dart';
export 'src/widgets/adaptive_dialog.dart';
export 'src/widgets/adaptive_drawer_scaffold.dart';
export 'src/widgets/adaptive_form_layout.dart';
export 'src/widgets/adaptive_form_submit.dart';
export 'src/widgets/adaptive_grid.dart';
export 'src/widgets/adaptive_image.dart';
export 'src/widgets/adaptive_layout.dart';
export 'src/widgets/adaptive_master_detail.dart';
export 'src/widgets/adaptive_navigation.dart';
export 'src/widgets/adaptive_padding.dart';
export 'src/widgets/adaptive_sized_box.dart';
export 'src/widgets/adaptive_sliver_grid.dart';
export 'src/widgets/adaptive_spacing.dart';
export 'src/widgets/adaptive_text.dart';
export 'src/widgets/adaptive_text_field.dart';
export 'src/widgets/adaptive_wrap.dart';
export 'src/widgets/animated_adaptive_layout.dart';
