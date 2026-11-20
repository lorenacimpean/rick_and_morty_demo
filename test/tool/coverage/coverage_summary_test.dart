import 'package:flutter_test/flutter_test.dart';

import '../../../tool/coverage/coverage_summary.dart';

void main() {
  group('fromLcov', () {
    test('counts hit and missed lines per file and in total', () {
      // Arrange
      const lcov = '''
SF:lib/a.dart
DA:1,3
DA:2,0
end_of_record
SF:lib/b.dart
DA:1,1
DA:2,1
end_of_record
''';

      // Act
      final summary = CoverageSummary.fromLcov(lcov);

      // Assert
      expect(summary.total, 75);
      expect(summary.files, {'lib/a.dart': 50.0, 'lib/b.dart': 100.0});
    });

    test('counts a file with no lines as fully covered', () {
      // Arrange
      const lcov = 'SF:lib/empty.dart\nend_of_record\n';

      // Act
      final summary = CoverageSummary.fromLcov(lcov);

      // Assert
      expect(summary.total, 100);
      expect(summary.files, {'lib/empty.dart': 100.0});
    });

    test('ignores checksums and malformed hit counts', () {
      // Arrange
      const lcov = 'SF:lib/a.dart\nDA:1,2,abc\nDA:2,x\nDA:3\nend_of_record\n';

      // Act
      final summary = CoverageSummary.fromLcov(lcov);

      // Assert
      expect(summary.files['lib/a.dart'], closeTo(33.33, 0.01));
    });

    test('is empty for an empty report', () {
      // Act
      final summary = CoverageSummary.fromLcov('');

      // Assert
      expect(summary.total, 100);
      expect(summary.files, isEmpty);
    });
  });

  group('json', () {
    test('reads back what it writes', () {
      // Arrange
      const summary = CoverageSummary(total: 80, files: {'lib/a.dart': 80});

      // Act
      final copy = CoverageSummary.fromJson(summary.toJson());

      // Assert
      expect(copy.total, summary.total);
      expect(copy.files, summary.files);
    });

    test('reads whole numbers as doubles', () {
      // Act
      final summary = CoverageSummary.fromJson({
        'total': 90,
        'files': {'lib/a.dart': 90},
      });

      // Assert
      expect(summary.total, 90.0);
      expect(summary.files, {'lib/a.dart': 90.0});
    });
  });
}
