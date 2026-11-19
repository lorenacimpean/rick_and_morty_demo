import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_state.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_view_model.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  const seasons = [MockObjects.seasonMaximal];

  late MockWatchEpisodesBySeason watchEpisodesBySeason;

  Future<void> tick() => Future<void>.delayed(Duration.zero);

  // A factory, because retry watches again.
  void stubSeasons(Stream<List<Season>> Function() watch) =>
      when(() => watchEpisodesBySeason()).thenAnswer((_) => watch());

  setUp(() => watchEpisodesBySeason = MockWatchEpisodesBySeason());

  group('init', () {
    blocTest<EpisodesViewModel, EpisodesState>(
      'emits the seasons',
      build: () {
        stubSeasons(() => Stream.value(seasons));
        return EpisodesViewModel(watchEpisodesBySeason);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const EpisodesState.success(seasons)],
      verify: (_) => verify(() => watchEpisodesBySeason()).called(1),
    );

    blocTest<EpisodesViewModel, EpisodesState>(
      'emits an empty success when there are no episodes',
      build: () {
        stubSeasons(() => Stream.value(const []));
        return EpisodesViewModel(watchEpisodesBySeason);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const EpisodesState.success([])],
      verify: (_) => verify(() => watchEpisodesBySeason()).called(1),
    );

    blocTest<EpisodesViewModel, EpisodesState>(
      'emits the error type when loading fails',
      build: () {
        stubSeasons(() => Stream.error(const AppException(.server)));
        return EpisodesViewModel(watchEpisodesBySeason);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const EpisodesState.error(.server)],
      verify: (_) => verify(() => watchEpisodesBySeason()).called(1),
    );

    blocTest<EpisodesViewModel, EpisodesState>(
      'reports an unexpected error as generic',
      build: () {
        stubSeasons(() => Stream.error(Exception('boom')));
        return EpisodesViewModel(watchEpisodesBySeason);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const EpisodesState.error(.generic)],
      verify: (_) => verify(() => watchEpisodesBySeason()).called(1),
    );
  });

  group('retry', () {
    blocTest<EpisodesViewModel, EpisodesState>(
      'shows loading, then watches the seasons again',
      build: () {
        stubSeasons(() => Stream.error(const AppException(.noConnection)));
        return EpisodesViewModel(watchEpisodesBySeason);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        stubSeasons(() => Stream.value(seasons));
        viewModel.retry();
      },
      expect: () => [
        const EpisodesState.error(.noConnection),
        const EpisodesState.loading(),
        const EpisodesState.success(seasons),
      ],
      verify: (_) => verify(() => watchEpisodesBySeason()).called(2),
    );
  });
}
