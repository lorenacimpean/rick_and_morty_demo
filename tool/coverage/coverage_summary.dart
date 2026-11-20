import 'dart:convert';

// Total and per-file line coverage, in percent.
class CoverageSummary {
  final double total;
  final Map<String, double> files;

  const CoverageSummary({required this.total, required this.files});

  // Reads the DA (line, hit count) records of each SF (source file) in lcov.info.
  factory CoverageSummary.fromLcov(String lcov) {
    final lines = <String, ({int found, int hit})>{};
    var file = '';
    for (final line in const LineSplitter().convert(lcov)) {
      if (line.startsWith('SF:')) {
        file = line.substring('SF:'.length);
        lines[file] = (found: 0, hit: 0);
      } else if (line.startsWith('DA:')) {
        final counts = lines[file] ?? (found: 0, hit: 0);
        lines[file] = (
          found: counts.found + 1,
          hit: counts.hit + (_isHit(line) ? 1 : 0),
        );
      }
    }
    return CoverageSummary._fromCounts(lines);
  }

  factory CoverageSummary.fromJson(Map<String, Object?> json) =>
      CoverageSummary(
        total: (json['total'] as num).toDouble(),
        files: {
          for (final MapEntry(:key, :value)
              in (json['files'] as Map<String, Object?>).entries)
            key: (value as num).toDouble(),
        },
      );

  factory CoverageSummary._fromCounts(
    Map<String, ({int found, int hit})> lines,
  ) {
    final found = lines.values.fold(0, (sum, file) => sum + file.found);
    final hit = lines.values.fold(0, (sum, file) => sum + file.hit);
    return CoverageSummary(
      total: _percent(found: found, hit: hit),
      files: {
        for (final MapEntry(:key, :value) in lines.entries)
          key: _percent(found: value.found, hit: value.hit),
      },
    );
  }

  Map<String, Object?> toJson() => {'total': total, 'files': files};

  // DA:<line>,<hit count>[,<checksum>]
  static bool _isHit(String line) {
    final fields = line.substring('DA:'.length).split(',');
    return fields.length > 1 && (int.tryParse(fields[1]) ?? 0) > 0;
  }

  // A file with no lines to cover counts as fully covered.
  static double _percent({required int found, required int hit}) =>
      found == 0 ? 100 : hit * 100 / found;
}
