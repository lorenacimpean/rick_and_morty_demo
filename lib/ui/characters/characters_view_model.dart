import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_state.dart';
import 'package:rxdart/rxdart.dart';

// A filter and how many pages of it to watch.
typedef _Request = ({CharactersFilter filter, int pages});

class CharactersViewModel extends Cubit<CharactersState> {
  static const kSearchDebounce = Duration(milliseconds: 300);

  final CharactersRepository _repository;
  final _requests = PublishSubject<_Request>();
  final _names = PublishSubject<String>();
  final _loadMore = PublishSubject<void>();
  StreamSubscription<List<CharactersPage>>? _pagesSubscription;
  StreamSubscription<String>? _searchSubscription;

  CharactersViewModel(this._repository)
    : super(const CharactersState.loading());

  void load() {
    _searchSubscription ??= _names
        .debounceTime(kSearchDebounce)
        .listen(_onSearch);
    // switchMap drops the old filter's pages as soon as a new request comes in.
    _pagesSubscription ??= _requests
        .switchMap(_watchPages)
        .listen(_onPages, onError: _onError);
    _requests.add((filter: state.filter, pages: 1));
  }

  void search(String name) => _names.add(name);

  void selectStatus(CharacterStatus? status) =>
      _setFilter(state.filter.copyWith(status: status));

  void loadMore() {
    if (state case final CharactersSuccess success
        when success.hasMore &&
            !success.isLoadingMore &&
            success.pageError == null) {
      emit(success.copyWith(isLoadingMore: true));
      _loadMore.add(null);
    }
  }

  void retry() {
    switch (state) {
      case final CharactersSuccess success:
        emit(success.copyWith(isLoadingMore: true, pageError: null));
        // Cached pages come back at once; the failed one is fetched again.
        _requests.add((filter: success.filter, pages: success.pageCount + 1));
      case final state:
        emit(CharactersState.loading(filter: state.filter));
        _requests.add((filter: state.filter, pages: 1));
    }
  }

  void _onSearch(String name) {
    final trimmed = name.trim();
    _setFilter(state.filter.copyWith(name: trimmed.isEmpty ? null : trimmed));
  }

  void _setFilter(CharactersFilter filter) {
    if (filter == state.filter) return;
    emit(CharactersState.loading(filter: filter));
    _requests.add((filter: filter, pages: 1));
  }

  // Watches pages 1 to n, then one more on each loadMore, all at once.
  Stream<List<CharactersPage>> _watchPages(_Request request) =>
      Rx.concat([
            Stream.fromIterable([for (var p = 1; p <= request.pages; p++) p]),
            _loadMore.scan<int>((last, _, _) => last + 1, request.pages),
          ])
          .flatMap(
            (page) => _repository
                .watchCharacters(page: page, filter: request.filter)
                .map((result) => (page, result)),
          )
          .scan<SplayTreeMap<int, CharactersPage>>(
            (pages, entry, _) => pages..[entry.$1] = entry.$2,
            SplayTreeMap(),
          )
          .map((pages) => pages.values.toList());

  void _onPages(List<CharactersPage> pages) {
    final previous = state;
    emit(
      CharactersState.success(
        filter: state.filter,
        characters: [for (final page in pages) ...page.characters],
        hasMore: pages.last.info.next != null,
        pageCount: pages.length,
        // Still loading until a page beyond the ones we had arrives.
        isLoadingMore:
            previous is CharactersSuccess &&
            previous.isLoadingMore &&
            pages.length <= previous.pageCount,
      ),
    );
  }

  void _onError(Object error) {
    final type = error is AppException ? error.type : AppErrorType.generic;
    emit(switch (state) {
      final CharactersSuccess success => success.copyWith(
        isLoadingMore: false,
        pageError: type,
      ),
      final state => CharactersState.error(filter: state.filter, error: type),
    });
  }

  @override
  Future<void> close() async {
    await _pagesSubscription?.cancel();
    await _searchSubscription?.cancel();
    await Future.wait([_requests.close(), _names.close(), _loadMore.close()]);
    return super.close();
  }
}
