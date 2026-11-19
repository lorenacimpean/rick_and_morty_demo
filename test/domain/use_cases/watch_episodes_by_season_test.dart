import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/episodes_page.dart';
import 'package:rick_and_morty_demo/data/models/page_info.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_episodes_by_season.dart';

import '../../mocks/mocks.dart';

void main() {
  const s1e1 = Episode(id: '1', code: 'S01E01');
  const s1e2 = Episode(id: '2', code: 'S01E02');
  const s2e1 = Episode(id: '3', code: 'S02E01');
  const special = Episode(id: '4', code: 'Special');

  late MockEpisodesRepository repository;
  late WatchEpisodesBySeason watchEpisodesBySeason;

  // Factories, because page 1 is watched twice: for the count, then the data.
  void stubPages(Map<int, Stream<EpisodesPage> Function()> pages) =>
      when(() => repository.watchEpisodes(page: any(named: 'page'))).thenAnswer(
        (invocation) =>
            pages[invocation.namedArguments[#page]]?.call() ??
            const Stream.empty(),
      );

  setUp(() {
    repository = MockEpisodesRepository();
    watchEpisodesBySeason = WatchEpisodesBySeason(repository);
  });

  group('call', () {
    test('groups one page by season, sorted by season and number', () async {
      // Arrange
      stubPages({
        1: () => Stream.value(const EpisodesPage(episodes: [s2e1, s1e2, s1e1])),
      });

      // Act
      final stream = watchEpisodesBySeason();

      // Assert
      await expectLater(
        stream,
        emits(const [
          Season(number: 1, episodes: [s1e1, s1e2]),
          Season(number: 2, episodes: [s2e1]),
        ]),
      );
      verify(() => repository.watchEpisodes(page: 1)).called(2);
    });

    test('combines every page the first page announces', () async {
      // Arrange
      stubPages({
        1: () => Stream.value(
          const EpisodesPage(
            episodes: [s1e1],
            info: PageInfo(next: 2, pages: 2),
          ),
        ),
        2: () => Stream.value(const EpisodesPage(episodes: [s2e1])),
      });

      // Act
      final stream = watchEpisodesBySeason();

      // Assert
      await expectLater(
        stream,
        emits(const [
          Season(number: 1, episodes: [s1e1]),
          Season(number: 2, episodes: [s2e1]),
        ]),
      );
      verify(() => repository.watchEpisodes(page: 2)).called(1);
    });

    test('puts codes that are not SxxEyy in season 0, first', () async {
      // Arrange
      stubPages({
        1: () => Stream.value(const EpisodesPage(episodes: [s1e1, special])),
      });

      // Act
      final stream = watchEpisodesBySeason();

      // Assert
      await expectLater(
        stream,
        emits(const [
          Season(number: 0, episodes: [special]),
          Season(number: 1, episodes: [s1e1]),
        ]),
      );
      verify(() => repository.watchEpisodes(page: 1)).called(2);
    });

    test('emits no seasons when there are no episodes', () async {
      // Arrange
      stubPages({1: () => Stream.value(const EpisodesPage())});

      // Act
      final stream = watchEpisodesBySeason();

      // Assert
      await expectLater(stream, emits(<Season>[]));
      verify(() => repository.watchEpisodes(page: 1)).called(2);
    });

    test('passes errors on', () async {
      // Arrange
      stubPages({1: () => Stream.error(const AppException(.noConnection))});

      // Act
      final stream = watchEpisodesBySeason();

      // Assert
      await expectLater(stream, emitsError(isA<AppException>()));
      verify(() => repository.watchEpisodes(page: 1)).called(1);
    });
  });
}
