import 'coverage_summary.dart';

// What the PR comment, the run summary and the README badge show.
class CoverageReport {
  static const kGood = 80.0;
  static const kFair = 60.0;
  static const _kMaxRows = 20;

  final CoverageSummary current;
  final CoverageSummary? base;
  final double minimum;

  const CoverageReport({
    required this.current,
    required this.base,
    required this.minimum,
  });

  bool get passed => current.total >= minimum;

  // shields.io colour for a percentage.
  static String colorOf(double percent) => switch (percent) {
    >= kGood => 'brightgreen',
    >= kFair => 'orange',
    _ => 'red',
  };

  // shields.io endpoint JSON for the README badge.
  Map<String, Object?> badge() => {
    'schemaVersion': 1,
    'label': 'coverage',
    'message': '${_format(current.total)}%',
    'color': colorOf(current.total),
  };

  String markdown({required String reportUrl, required String historyUrl}) => [
    '## Coverage',
    '',
    '${_badgeImage()} &nbsp; **${_format(current.total)}%** ${_change()}',
    '',
    _verdict(),
    '',
    ..._fileTable(),
    '[Full report]($reportUrl) · [History]($historyUrl)',
    '',
  ].join('\n');

  String _badgeImage() {
    final message = Uri.encodeComponent('${_format(current.total)}%');
    final color = colorOf(current.total);
    return '![coverage](https://img.shields.io/badge/coverage-$message-$color)';
  }

  String _change() => switch (base) {
    final base? =>
      '${_delta(base.total, current.total)} vs master (${_format(base.total)}%)',
    null => '(no master report yet)',
  };

  String _verdict() => passed
      ? '✅ Above the ${_format(minimum)}% minimum'
      : '❌ Below the ${_format(minimum)}% minimum';

  List<String> _fileTable() {
    final rows = _changedFiles();
    if (rows.isEmpty) return const [];
    return [
      '| File | master | This change | Change |',
      '| --- | ---: | ---: | ---: |',
      for (final file in rows.take(_kMaxRows)) _row(file),
      if (rows.length > _kMaxRows)
        '| … ${rows.length - _kMaxRows} more | | | |',
      '',
    ];
  }

  // Files whose coverage changed, the biggest change first.
  List<String> _changedFiles() {
    final base = this.base;
    if (base == null) return const [];
    final files = {
      ...base.files.keys,
      ...current.files.keys,
    }.where((file) => base.files[file] != current.files[file]).toList();
    return files..sort((a, b) => _size(b).compareTo(_size(a)));
  }

  double _size(String file) =>
      ((current.files[file] ?? 0) - (base?.files[file] ?? 0)).abs();

  String _row(String file) {
    final before = base?.files[file];
    final after = current.files[file];
    final change = before != null && after != null
        ? _delta(before, after)
        : (after == null ? 'removed' : 'new');
    return '| `$file` | ${_cell(before)} | ${_cell(after)} | $change |';
  }

  static String _cell(double? percent) =>
      percent == null ? '—' : '${_format(percent)}%';

  static String _delta(double before, double after) {
    final change = after - before;
    return switch (change) {
      > 0 => '▲ +${_format(change)}%',
      < 0 => '▼ −${_format(change.abs())}%',
      _ => '= 0.0%',
    };
  }

  static String _format(double percent) => percent.toStringAsFixed(1);
}
