import 'dart:convert';
import 'dart:io';

import 'coverage/coverage_report.dart';
import 'coverage/coverage_summary.dart';

// Usage: dart run tool/coverage_report.dart --lcov=… --out=… --sha=…
//   --report-url=… --history-url=… [--base=summary.json] [--history=history.json]
//   [--minimum=80]
// Writes comment.md, summary.json, badge.json and history.json to --out.
Future<void> main(List<String> arguments) async {
  final args = _parse(arguments);
  final current = CoverageSummary.fromLcov(
    await File(args['lcov']!).readAsString(),
  );
  final report = CoverageReport(
    current: current,
    base: await _readBase(args['base']),
    minimum: double.parse(args['minimum'] ?? '${CoverageReport.kGood}'),
  );
  final out = await Directory(args['out']!).create(recursive: true);
  await _write(
    out,
    'comment.md',
    report.markdown(
      reportUrl: args['report-url']!,
      historyUrl: args['history-url']!,
    ),
  );
  await _writeJson(out, 'summary.json', current.toJson());
  await _writeJson(out, 'badge.json', report.badge());
  await _writeJson(out, 'history.json', [
    ...await _readHistory(args['history']),
    _historyEntry(sha: args['sha']!, total: current.total),
  ]);
  await _setOutputs(total: current.total, passed: report.passed);
}

// --name=value pairs.
Map<String, String> _parse(List<String> arguments) => {
  for (final argument in arguments)
    if (argument.startsWith('--') && argument.contains('='))
      argument.substring(2, argument.indexOf('=')): argument.substring(
        argument.indexOf('=') + 1,
      ),
};

Future<CoverageSummary?> _readBase(String? path) async {
  final file = path == null ? null : File(path);
  if (file == null || !await file.exists()) return null;
  return CoverageSummary.fromJson(
    jsonDecode(await file.readAsString()) as Map<String, Object?>,
  );
}

Future<List<Object?>> _readHistory(String? path) async {
  final file = path == null ? null : File(path);
  if (file == null || !await file.exists()) return const [];
  return jsonDecode(await file.readAsString()) as List<Object?>;
}

Map<String, Object?> _historyEntry({
  required String sha,
  required double total,
}) => {
  'sha': sha,
  'date': DateTime.now().toUtc().toIso8601String(),
  'total': double.parse(total.toStringAsFixed(2)),
};

Future<void> _write(Directory out, String name, String content) =>
    File('${out.path}/$name').writeAsString(content);

Future<void> _writeJson(Directory out, String name, Object json) =>
    _write(out, name, const JsonEncoder.withIndent('  ').convert(json));

// Step outputs for the workflow; skipped when run locally.
Future<void> _setOutputs({required double total, required bool passed}) async {
  final path = Platform.environment['GITHUB_OUTPUT'];
  if (path == null) return;
  await File(path).writeAsString(
    'total=${total.toStringAsFixed(1)}\npassed=$passed\n',
    mode: FileMode.append,
  );
}
