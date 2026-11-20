import 'package:flutter_test/flutter_test.dart';

import '../../../tool/coverage/coverage_report.dart';
import '../../../tool/coverage/coverage_summary.dart';

void main() {
  const reportUrl = 'https://example.com/pr/1/';
  const historyUrl = 'https://example.com/';

  CoverageReport report({
    required double total,
    Map<String, double> files = const {},
    CoverageSummary? base,
  }) => CoverageReport(
    current: CoverageSummary(total: total, files: files),
    base: base,
    minimum: 80,
  );

  String markdown(CoverageReport report) =>
      report.markdown(reportUrl: reportUrl, historyUrl: historyUrl);

  group('colorOf', () {
    test('is green from 80%, orange from 60%, red below', () {
      // Act
      final colors = [
        100.0,
        80.0,
        79.9,
        60.0,
        59.9,
        0.0,
      ].map(CoverageReport.colorOf);

      // Assert
      expect(colors, [
        'brightgreen',
        'brightgreen',
        'orange',
        'orange',
        'red',
        'red',
      ]);
    });
  });

  group('passed', () {
    test('passes at the minimum and fails below it', () {
      // Act
      final atMinimum = report(total: 80).passed;
      final below = report(total: 79.9).passed;

      // Assert
      expect(atMinimum, isTrue);
      expect(below, isFalse);
    });
  });

  group('badge', () {
    test('shows the total with its colour', () {
      // Act
      final badge = report(total: 72.345).badge();

      // Assert
      expect(badge, {
        'schemaVersion': 1,
        'label': 'coverage',
        'message': '72.3%',
        'color': 'orange',
      });
    });
  });

  group('markdown', () {
    test('shows the total, the verdict and the links', () {
      // Act
      final text = markdown(report(total: 85));

      // Assert
      expect(text, contains('**85.0%**'));
      expect(text, contains('coverage-85.0%25-brightgreen'));
      expect(text, contains('✅ Above the 80.0% minimum'));
      expect(
        text,
        contains('[Full report]($reportUrl) · [History]($historyUrl)'),
      );
    });

    test('says there is no master report without a base', () {
      // Act
      final text = markdown(report(total: 85, files: {'lib/a.dart': 85}));

      // Assert
      expect(text, contains('(no master report yet)'));
      expect(text, isNot(contains('| File |')));
    });

    test('fails the verdict below the minimum', () {
      // Act
      final text = markdown(report(total: 50));

      // Assert
      expect(text, contains('❌ Below the 80.0% minimum'));
      expect(text, contains('-red)'));
    });

    test('shows an increase against master', () {
      // Arrange
      const base = CoverageSummary(total: 80, files: {});

      // Act
      final text = markdown(report(total: 82.5, base: base));

      // Assert
      expect(text, contains('▲ +2.5% vs master (80.0%)'));
    });

    test('shows a decrease against master', () {
      // Arrange
      const base = CoverageSummary(total: 90, files: {});

      // Act
      final text = markdown(report(total: 85, base: base));

      // Assert
      expect(text, contains('▼ −5.0% vs master (90.0%)'));
    });

    test('shows no change against master', () {
      // Arrange
      const base = CoverageSummary(total: 85, files: {});

      // Act
      final text = markdown(report(total: 85, base: base));

      // Assert
      expect(text, contains('= 0.0% vs master'));
    });

    test('lists changed, new and removed files, biggest change first', () {
      // Arrange
      const base = CoverageSummary(
        total: 80,
        files: {
          'lib/same.dart': 90,
          'lib/small.dart': 80,
          'lib/big.dart': 50,
          'lib/removed.dart': 70,
        },
      );

      // Act
      final text = markdown(
        report(
          total: 85,
          base: base,
          files: {
            'lib/same.dart': 90,
            'lib/small.dart': 81,
            'lib/big.dart': 100,
            'lib/new.dart': 60,
          },
        ),
      );

      // Assert
      final rows = text.split('\n').where((line) => line.startsWith('| `'));
      expect(rows, [
        '| `lib/removed.dart` | 70.0% | — | removed |',
        '| `lib/new.dart` | — | 60.0% | new |',
        '| `lib/big.dart` | 50.0% | 100.0% | ▲ +50.0% |',
        '| `lib/small.dart` | 80.0% | 81.0% | ▲ +1.0% |',
      ]);
    });

    test('caps the table at 20 files', () {
      // Arrange
      final base = CoverageSummary(
        total: 50,
        files: {for (var i = 0; i < 25; i++) 'lib/f$i.dart': 50},
      );

      // Act
      final text = markdown(
        report(
          total: 60,
          base: base,
          files: {for (var i = 0; i < 25; i++) 'lib/f$i.dart': 60},
        ),
      );

      // Assert
      final rows = text.split('\n').where((line) => line.startsWith('| `'));
      expect(rows, hasLength(20));
      expect(text, contains('| … 5 more | | | |'));
    });
  });
}
