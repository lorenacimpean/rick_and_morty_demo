import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_state.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  const defaultFilter = CharactersFilter();
  const firstPage = MockObjects.charactersPageMaximal;
  const lastPage = MockObjects.charactersPageLast;
  const noConnection = AppException(.noConnection);

  late MockCharactersRepository repository;

  // Lets the repository's streams deliver before the next action.
  Future<void> tick() => Future<void>.delayed(Duration.zero);

  Future<void> afterDebounce() =>
      Future<void>.delayed(CharactersViewModel.kSearchDebounce * 2);

  // Factories, because loadMore watches the earlier pages again.
  void stubPages(Map<int, Stream<CharactersPage> Function()> pages) =>
      when(
        () => repository.watchCharacters(
          page: any(named: 'page'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (invocation) =>
            pages[invocation.namedArguments[#page]]?.call() ??
            const Stream.empty(),
      );

  void verifyWatched(int page, CharactersFilter filter, int times) =>
      verify(() => repository.watchCharacters(page: page, filter: filter))
          .called(times);

  CharactersSuccess success({
    CharactersFilter filter = defaultFilter,
    List<CharactersPage> pages = const [firstPage],
    bool isLoadingMore = false,
    AppErrorType? pageError,
  }) => CharactersState.success(
    filter: filter,
    characters: [for (final page in pages) ...page.characters],
    hasMore: pages.last.info.next != null,
    pageCount: pages.length,
    isLoadingMore: isLoadingMore,
    pageError: pageError,
  ) as CharactersSuccess;

  setUpAll(() => registerFallbackValue(defaultFilter));

  setUp(() => repository = MockCharactersRepository());

  group('init', () {
    blocTest<CharactersViewModel, CharactersState>(
      'emits the first page',
      build: () {
        stubPages({1: () => Stream.value(firstPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [success()],
      verify: (_) => verifyWatched(1, defaultFilter, 1),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'emits an empty success when nothing matches',
      build: () {
        stubPages({1: () => Stream.value(MockObjects.charactersPageMinimal)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [
        success(pages: [MockObjects.charactersPageMinimal]),
      ],
      verify: (_) => verifyWatched(1, defaultFilter, 1),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'emits the error type when the first page fails',
      build: () {
        stubPages({1: () => Stream.error(noConnection)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [
        const CharactersState.error(
          filter: defaultFilter,
          error: .noConnection,
        ),
      ],
      verify: (_) => verifyWatched(1, defaultFilter, 1),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'reports an unexpected error as generic',
      build: () {
        stubPages({1: () => Stream.error(Exception('boom'))});
        return CharactersViewModel(repository);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [
        const CharactersState.error(filter: defaultFilter, error: .generic),
      ],
      verify: (_) => verifyWatched(1, defaultFilter, 1),
    );
  });

  group('loadMore', () {
    blocTest<CharactersViewModel, CharactersState>(
      'appends the next page',
      build: () {
        stubPages({
          1: () => Stream.value(firstPage),
          2: () => Stream.value(lastPage),
        });
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.loadMore();
      },
      expect: () => [
        success(),
        success(isLoadingMore: true),
        success(pages: [firstPage, lastPage]),
      ],
      verify: (_) => verifyWatched(2, defaultFilter, 1),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'does nothing on the last page',
      build: () {
        stubPages({1: () => Stream.value(lastPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.loadMore();
      },
      expect: () => [
        success(pages: [lastPage]),
      ],
      verify: (_) => verifyNever(
        () => repository.watchCharacters(page: 2, filter: any(named: 'filter')),
      ),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'keeps the list and shows the error when the next page fails',
      build: () {
        stubPages({
          1: () => Stream.value(firstPage),
          2: () => Stream.error(noConnection),
        });
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.loadMore();
      },
      expect: () => [
        success(),
        success(isLoadingMore: true),
        success(pageError: .noConnection),
      ],
      verify: (_) => verifyWatched(2, defaultFilter, 1),
    );
  });

  group('search', () {
    blocTest<CharactersViewModel, CharactersState>(
      'reloads with the trimmed name after the debounce',
      build: () {
        stubPages({1: () => Stream.value(firstPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.search('  Rick ');
        await afterDebounce();
      },
      expect: () => [
        success(),
        const CharactersState.loading(filter: CharactersFilter(name: 'Rick')),
        success(filter: const CharactersFilter(name: 'Rick')),
      ],
      verify: (_) => verifyWatched(1, const CharactersFilter(name: 'Rick'), 1),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'clears the name for a blank search',
      build: () {
        stubPages({1: () => Stream.value(firstPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.search('Rick');
        await afterDebounce();
        viewModel.search('   ');
        await afterDebounce();
      },
      expect: () => [
        success(),
        const CharactersState.loading(filter: CharactersFilter(name: 'Rick')),
        success(filter: const CharactersFilter(name: 'Rick')),
        const CharactersState.loading(),
        success(),
      ],
      verify: (_) => verifyWatched(1, defaultFilter, 2),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'does not reload when the filter stays the same',
      build: () {
        stubPages({1: () => Stream.value(firstPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.search('');
        await afterDebounce();
      },
      expect: () => [success()],
      verify: (_) => verifyWatched(1, defaultFilter, 1),
    );
  });

  group('selectStatus', () {
    blocTest<CharactersViewModel, CharactersState>(
      'reloads with the status',
      build: () {
        stubPages({1: () => Stream.value(firstPage)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.selectStatus(.dead);
      },
      expect: () => [
        success(),
        const CharactersState.loading(filter: CharactersFilter(status: .dead)),
        success(filter: const CharactersFilter(status: .dead)),
      ],
      verify: (_) => verifyWatched(1, const CharactersFilter(status: .dead), 1),
    );
  });

  group('retry', () {
    blocTest<CharactersViewModel, CharactersState>(
      'starts over after the first page failed',
      build: () {
        stubPages({1: () => Stream.error(noConnection)});
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        stubPages({1: () => Stream.value(firstPage)});
        viewModel.retry();
      },
      expect: () => [
        const CharactersState.error(
          filter: defaultFilter,
          error: .noConnection,
        ),
        const CharactersState.loading(),
        success(),
      ],
      verify: (_) => verifyWatched(1, defaultFilter, 2),
    );

    blocTest<CharactersViewModel, CharactersState>(
      'watches the loaded pages and the failed one again',
      build: () {
        stubPages({
          1: () => Stream.value(firstPage),
          2: () => Stream.error(noConnection),
        });
        return CharactersViewModel(repository);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        viewModel.loadMore();
        await tick();
        stubPages({
          1: () => Stream.value(firstPage),
          2: () => Stream.value(lastPage),
        });
        viewModel.retry();
      },
      expect: () => [
        success(),
        success(isLoadingMore: true),
        success(pageError: .noConnection),
        success(isLoadingMore: true),
        success(pages: [firstPage, lastPage]),
      ],
      verify: (_) => verifyWatched(2, defaultFilter, 2),
    );
  });
}
