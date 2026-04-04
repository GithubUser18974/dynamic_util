import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('Breakpoint', () {
    test('enum has three values', () {
      expect(Breakpoint.values.length, 3);
    });
  });

  group('BreakpointConfig', () {
    const config = BreakpointConfig();

    test('default thresholds', () {
      expect(config.smallMax, 600);
      expect(config.largeMin, 1024);
    });

    test('width < 600 → small', () {
      expect(config.breakpointForWidth(320), Breakpoint.small);
      expect(config.breakpointForWidth(599), Breakpoint.small);
    });

    test('width == 600 → medium', () {
      expect(config.breakpointForWidth(600), Breakpoint.medium);
    });

    test('width between 600 and 1024 → medium', () {
      expect(config.breakpointForWidth(768), Breakpoint.medium);
      expect(config.breakpointForWidth(1024), Breakpoint.medium);
    });

    test('width > 1024 → large', () {
      expect(config.breakpointForWidth(1025), Breakpoint.large);
      expect(config.breakpointForWidth(1920), Breakpoint.large);
    });

    test('custom thresholds work', () {
      const custom = BreakpointConfig(smallMax: 500, largeMin: 900);
      expect(custom.breakpointForWidth(499), Breakpoint.small);
      expect(custom.breakpointForWidth(500), Breakpoint.medium);
      expect(custom.breakpointForWidth(900), Breakpoint.medium);
      expect(custom.breakpointForWidth(901), Breakpoint.large);
    });
  });

  group('BreakpointHelper', () {
    test('isMobile returns true for small screens', () {
      expect(BreakpointHelper.isMobile(320), isTrue);
      expect(BreakpointHelper.isMobile(599), isTrue);
      expect(BreakpointHelper.isMobile(600), isFalse);
    });

    test('isTablet returns true for medium screens', () {
      expect(BreakpointHelper.isTablet(600), isTrue);
      expect(BreakpointHelper.isTablet(768), isTrue);
      expect(BreakpointHelper.isTablet(1024), isTrue);
      expect(BreakpointHelper.isTablet(320), isFalse);
      expect(BreakpointHelper.isTablet(1025), isFalse);
    });

    test('isDesktop returns true for large screens', () {
      expect(BreakpointHelper.isDesktop(1025), isTrue);
      expect(BreakpointHelper.isDesktop(1920), isTrue);
      expect(BreakpointHelper.isDesktop(1024), isFalse);
    });

    test('current returns correct breakpoint', () {
      expect(BreakpointHelper.current(320), Breakpoint.small);
      expect(BreakpointHelper.current(768), Breakpoint.medium);
      expect(BreakpointHelper.current(1920), Breakpoint.large);
    });

    test('custom config is respected', () {
      const custom = BreakpointConfig(smallMax: 400, largeMin: 800);
      expect(BreakpointHelper.isMobile(350, config: custom), isTrue);
      expect(BreakpointHelper.isTablet(500, config: custom), isTrue);
      expect(BreakpointHelper.isDesktop(801, config: custom), isTrue);
    });
  });
}
