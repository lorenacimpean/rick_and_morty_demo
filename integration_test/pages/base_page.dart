import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

// Shared waits and gestures. pumpAndSettle never ends while a spinner runs,
// so pages pump frames until what they wait for shows up.
abstract class BasePage {
  static const kTimeout = Duration(seconds: 30);
  static const kFrame = Duration(milliseconds: 100);
  // Longer than a page transition.
  static const _kTransition = Duration(milliseconds: 600);
  static const _kScrollStep = Offset(0, -300);

  final WidgetTester tester;

  const BasePage(this.tester);

  Future<void> checkScreenIsDisplayed();

  Future<void> tapAndPump(Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> tapAndSettle(Finder finder) async {
    await tapAndPump(finder);
    await tester.pump(_kTransition);
  }

  Future<void> waitFor(Finder finder) =>
      waitUntil(() => finder.evaluate().isNotEmpty, 'waiting for $finder');

  Future<void> waitUntilGone(Finder finder) =>
      waitUntil(() => finder.evaluate().isEmpty, 'waiting for $finder to go');

  Future<void> waitUntil(bool Function() condition, String what) async {
    final stopwatch = Stopwatch()..start();
    while (!condition()) {
      _failAfterTimeout(stopwatch, what);
      await tester.pump(kFrame);
    }
  }

  // Drags until the finder can be tapped; next pages may load on the way.
  Future<void> scrollUntilFound(
    Finder finder, {
    required Finder scrollable,
  }) async {
    final target = finder.hitTestable();
    final stopwatch = Stopwatch()..start();
    while (target.evaluate().isEmpty) {
      _failAfterTimeout(stopwatch, 'scrolling to $finder');
      await tester.drag(_scrollableIn(scrollable), _kScrollStep);
      await tester.pump(kFrame);
    }
  }

  // Drags in steps until nothing is left below; one long drag can bounce back first.
  Future<void> scrollToEnd(Finder scrollable) async {
    final view = _scrollableIn(scrollable);
    final stopwatch = Stopwatch()..start();
    while (tester.state<ScrollableState>(view).position.extentAfter > 0) {
      _failAfterTimeout(stopwatch, 'scrolling to the end of $scrollable');
      await tester.drag(view, _kScrollStep);
      await tester.pump(kFrame);
    }
  }

  Finder _scrollableIn(Finder scrollable) =>
      find.descendant(of: scrollable, matching: find.byType(Scrollable)).first;

  void _failAfterTimeout(Stopwatch stopwatch, String what) {
    if (stopwatch.elapsed > kTimeout) throw TestFailure('Timed out $what');
  }
}
