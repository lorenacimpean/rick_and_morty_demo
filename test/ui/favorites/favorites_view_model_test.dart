import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_state.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_view_model.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  const characters = [MockObjects.characterMaximal];

  late MockWatchFavoriteCharacters watchFavoriteCharacters;

  Future<void> tick() => Future<void>.delayed(Duration.zero);

  // A factory, because retry watches again.
  void stubFavorites(Stream<List<Character>> Function() watch) =>
      when(() => watchFavoriteCharacters()).thenAnswer((_) => watch());

  setUp(() => watchFavoriteCharacters = MockWatchFavoriteCharacters());

  group('init', () {
    blocTest<FavoritesViewModel, FavoritesState>(
      'emits the favorite characters',
      build: () {
        stubFavorites(() => Stream.value(characters));
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const FavoritesState.success(characters)],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(1),
    );

    blocTest<FavoritesViewModel, FavoritesState>(
      'emits an empty success when nothing is saved',
      build: () {
        stubFavorites(() => Stream.value(const []));
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const FavoritesState.success([])],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(1),
    );

    blocTest<FavoritesViewModel, FavoritesState>(
      'follows the favorites as they change',
      build: () {
        stubFavorites(
          () => Stream.fromIterable([const <Character>[], characters]),
        );
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [
        const FavoritesState.success([]),
        const FavoritesState.success(characters),
      ],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(1),
    );

    blocTest<FavoritesViewModel, FavoritesState>(
      'emits the error type when loading fails',
      build: () {
        stubFavorites(() => Stream.error(const AppException(.timeout)));
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const FavoritesState.error(.timeout)],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(1),
    );

    blocTest<FavoritesViewModel, FavoritesState>(
      'reports an unexpected error as generic',
      build: () {
        stubFavorites(() => Stream.error(Exception('boom')));
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const FavoritesState.error(.generic)],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(1),
    );
  });

  group('retry', () {
    blocTest<FavoritesViewModel, FavoritesState>(
      'shows loading, then watches the favorites again',
      build: () {
        stubFavorites(() => Stream.error(const AppException(.noConnection)));
        return FavoritesViewModel(watchFavoriteCharacters);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        stubFavorites(() => Stream.value(characters));
        viewModel.retry();
      },
      expect: () => [
        const FavoritesState.error(.noConnection),
        const FavoritesState.loading(),
        const FavoritesState.success(characters),
      ],
      verify: (_) => verify(() => watchFavoriteCharacters()).called(2),
    );
  });
}
