import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/episodes_page.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';
import 'package:rick_and_morty_demo/data/repos/episodes_repository.dart';
import 'package:rxdart/rxdart.dart';

// Every episode, grouped by season and sorted by season and episode number.
class WatchEpisodesBySeason {
  // Matches codes like S01E01.
  static final _kCode = RegExp(r'^S(\d+)E(\d+)$');

  final EpisodesRepository _repository;

  const WatchEpisodesBySeason(this._repository);

  // Page 1 says how many pages there are; then all of them are watched together.
  Stream<List<Season>> call() => _repository
      .watchEpisodes(page: 1)
      .map((first) => first.info.pages)
      .distinct()
      .switchMap(_watchPages)
      .map((pages) => _group([for (final page in pages) ...page.episodes]));

  Stream<List<EpisodesPage>> _watchPages(int pageCount) =>
      Rx.combineLatestList([
        for (var page = 1; page <= pageCount; page++)
          _repository.watchEpisodes(page: page),
      ]);

  // Sorted first, so seasons are added to the map in order.
  List<Season> _group(List<Episode> episodes) {
    final seasons = <int, List<Episode>>{};
    for (final episode in [...episodes]..sort(_byCode)) {
      seasons.putIfAbsent(_parse(episode.code).$1, () => []).add(episode);
    }
    return [
      for (final MapEntry(key: number, value: episodes) in seasons.entries)
        Season(number: number, episodes: episodes),
    ];
  }

  int _byCode(Episode a, Episode b) {
    final (seasonA, numberA) = _parse(a.code);
    final (seasonB, numberB) = _parse(b.code);
    return seasonA != seasonB
        ? seasonA.compareTo(seasonB)
        : numberA.compareTo(numberB);
  }

  // (season, episode). Codes that don't match go to season 0.
  (int, int) _parse(String code) => switch (_kCode.firstMatch(code)) {
    final match? => (_number(match.group(1)), _number(match.group(2))),
    null => (0, 0),
  };

  int _number(String? digits) => int.tryParse(digits ?? '') ?? 0;
}
