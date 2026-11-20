import 'dart:convert';

// Outcome of a test run, read from flutter test's JSON reporter output.
class TestResults {
  final int passed;
  final List<String> failed;

  const TestResults({required this.passed, required this.failed});

  // One JSON event per line; testStart names a test, testDone gives its result.
  // Hidden tests (suite loading) and skipped ones don't count.
  factory TestResults.fromJsonLines(String lines) {
    final names = <int, String>{};
    var passed = 0;
    final failed = <String>[];
    for (final event in _events(lines)) {
      switch (event) {
        case {
          'type': 'testStart',
          'test': {'id': final int id, 'name': final String name},
        }:
          names[id] = name;
        case {
          'type': 'testDone',
          'hidden': false,
          'skipped': false,
          'testID': final int id,
        }:
          event['result'] == 'success'
              ? passed++
              : failed.add(names[id] ?? 'test $id');
      }
    }
    return TestResults(passed: passed, failed: failed);
  }

  int get total => passed + failed.length;

  // No tests at all counts as 0%: the build or the device failed.
  double get passRate => total == 0 ? 0 : passed * 100 / total;

  bool meets(double minimum) => passRate >= minimum;

  String markdown(double minimum) => [
    '## Integration tests',
    '',
    '${meets(minimum) ? '✅' : '❌'} **$passed of $total passed** '
        '(${passRate.toStringAsFixed(1)}%, minimum ${minimum.toStringAsFixed(0)}%)',
    if (failed.isNotEmpty) ...[
      '',
      'Failed:',
      for (final name in failed) '- $name',
    ],
    '',
  ].join('\n');

  static Iterable<Map<String, Object?>> _events(String lines) =>
      const LineSplitter()
          .convert(lines)
          .where((line) => line.startsWith('{'))
          .map((line) => jsonDecode(line))
          .whereType<Map<String, Object?>>();
}
