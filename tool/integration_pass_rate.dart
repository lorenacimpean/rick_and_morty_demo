import 'dart:io';

import 'integration/test_results.dart';

// Usage: dart run tool/integration_pass_rate.dart <results.json> [--minimum=80]
// Fails when fewer than the minimum share of tests passed, or none ran.
Future<void> main(List<String> arguments) async {
  final file = File(arguments.first);
  final minimum = double.parse(
    arguments
            .where((argument) => argument.startsWith('--minimum='))
            .map((argument) => argument.substring('--minimum='.length))
            .firstOrNull ??
        '80',
  );
  final results = TestResults.fromJsonLines(
    await file.exists() ? await file.readAsString() : '',
  );
  final markdown = results.markdown(minimum);
  stdout.write(markdown);
  await _addToRunSummary(markdown);
  exitCode = results.meets(minimum) ? 0 : 1;
}

// Shown on the workflow run's page; skipped when run locally.
Future<void> _addToRunSummary(String markdown) async {
  final path = Platform.environment['GITHUB_STEP_SUMMARY'];
  if (path == null) return;
  await File(path).writeAsString(markdown, mode: FileMode.append);
}
