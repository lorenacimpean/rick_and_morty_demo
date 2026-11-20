import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/integration/test_results.dart';

String start(int id, String name) => jsonEncode({
  'type': 'testStart',
  'test': {'id': id, 'name': name},
});

String done(
  int id, {
  String result = 'success',
  bool hidden = false,
  bool skipped = false,
}) => jsonEncode({
  'type': 'testDone',
  'testID': id,
  'result': result,
  'hidden': hidden,
  'skipped': skipped,
});

void main() {
  group('fromJsonLines', () {
    test('counts passed and failed tests by name', () {
      // Arrange
      final lines = [
        start(1, 'a'),
        done(1),
        start(2, 'b'),
        done(2, result: 'failure'),
        start(3, 'c'),
        done(3, result: 'error'),
      ].join('\n');

      // Act
      final results = TestResults.fromJsonLines(lines);

      // Assert
      expect(results.passed, 1);
      expect(results.failed, ['b', 'c']);
      expect(results.total, 3);
    });

    test('ignores hidden and skipped tests', () {
      // Arrange
      final lines = [
        start(1, 'loading suite'),
        done(1, hidden: true),
        start(2, 'skipped'),
        done(2, skipped: true),
      ].join('\n');

      // Act
      final results = TestResults.fromJsonLines(lines);

      // Assert
      expect(results.total, 0);
    });

    test('ignores lines that are not events', () {
      // Arrange
      final lines = [
        'Running Xcode build...',
        start(1, 'a'),
        done(1),
        '[1]',
      ].join('\n');

      // Act
      final results = TestResults.fromJsonLines(lines);

      // Assert
      expect(results.passed, 1);
      expect(results.failed, isEmpty);
    });

    test('names an unknown test by its id', () {
      // Act
      final results = TestResults.fromJsonLines(done(7, result: 'failure'));

      // Assert
      expect(results.failed, ['test 7']);
    });
  });

  group('passRate', () {
    test('is the share of tests that passed', () {
      // Arrange
      const results = TestResults(passed: 4, failed: ['x']);

      // Act
      final rate = results.passRate;

      // Assert
      expect(rate, 80);
    });

    test('is 0 when no tests ran', () {
      // Arrange
      const results = TestResults(passed: 0, failed: []);

      // Act
      final rate = results.passRate;

      // Assert
      expect(rate, 0);
    });
  });

  group('meets', () {
    test('passes at the minimum and fails below it', () {
      // Arrange
      const atMinimum = TestResults(passed: 4, failed: ['x']);
      const below = TestResults(passed: 3, failed: ['x']);

      // Act & Assert
      expect(atMinimum.meets(80), isTrue);
      expect(below.meets(80), isFalse);
    });
  });

  group('markdown', () {
    test('shows the count and lists failed tests', () {
      // Arrange
      const results = TestResults(passed: 4, failed: ['x']);

      // Act
      final text = results.markdown(80);

      // Assert
      expect(text, contains('✅ **4 of 5 passed** (80.0%, minimum 80%)'));
      expect(text, contains('Failed:\n- x'));
    });

    test('marks a run below the minimum', () {
      // Arrange
      const results = TestResults(passed: 1, failed: ['x', 'y']);

      // Act
      final text = results.markdown(80);

      // Assert
      expect(text, contains('❌ **1 of 3 passed**'));
    });

    test('lists nothing when all passed', () {
      // Arrange
      const results = TestResults(passed: 2, failed: []);

      // Act
      final text = results.markdown(80);

      // Assert
      expect(text, isNot(contains('Failed:')));
    });
  });
}
