import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_state.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

// The filter to show and how many of its pages.
typedef _PagesRequest = ({CharactersFilter filter, int pageCount});

class CharactersViewModel extends AppCubit<CharactersState> {
  static const kSearchDebounce = Duration(milliseconds: 300);

  final CharactersRepository _repository;
  final PublishSubject<_PagesRequest> _requests;
  final PublishSubject<String> _searches;

  CharactersViewModel(CharactersRepository repository)
    : this._(repository, PublishSubject(), PublishSubject());

  // Private so the subjects can be handed to AppCubit, which closes them.
  CharactersViewModel._(this._repository, this._requests, this._searches)
    : super(const CharactersState.loading(), subjects: [_requests, _searches]);

  @override
  void init() {
    listenTo(_searches.debounceTime(kSearchDebounce), _onSearch);
    // switchMap stops watching the old request as soon as a new one comes in.
    listenTo(_requests.switchMap(_watchPages), _onPages, onError: _onError);
    _request(pageCount: 1);
  }

  void search(String name) => _searches.add(name);

  void selectStatus(CharacterStatus? status) =>
      _changeFilter(state.filter.copyWith(status: status));

  void loadMore() {
    if (state case final CharactersSuccess success when _canLoadMore(success)) {
      emit(success.copyWith(isLoadingMore: true));
      _request(pageCount: success.pageCount + 1);
    }
  }

  void retry() {
    final state = this.state;
    if (state is CharactersSuccess) {
      // The next page failed: ask for it again, the list stays on screen.
      emit(state.copyWith(isLoadingMore: true, pageError: null));
      _request(pageCount: state.pageCount + 1);
    } else {
      emit(CharactersState.loading(filter: state.filter));
      _request(pageCount: 1);
    }
  }

  void _onSearch(String name) {
    final trimmed = name.trim();
    _changeFilter(
      state.filter.copyWith(name: trimmed.isEmpty ? null : trimmed),
    );
  }

  void _changeFilter(CharactersFilter filter) {
    if (filter == state.filter) return;
    emit(CharactersState.loading(filter: filter));
    _request(pageCount: 1);
  }

  bool _canLoadMore(CharactersSuccess success) =>
      success.hasMore && !success.isLoadingMore && success.pageError == null;

  void _request({required int pageCount}) =>
      _requests.add((filter: state.filter, pageCount: pageCount));

  // Emits once every page has arrived, then again whenever one of them updates.
  Stream<List<CharactersPage>> _watchPages(_PagesRequest request) =>
      Rx.combineLatestList([
        for (var page = 1; page <= request.pageCount; page++)
          _repository.watchCharacters(page: page, filter: request.filter),
      ]);

  void _onPages(List<CharactersPage> pages) => emit(
    CharactersState.success(
      filter: state.filter,
      characters: [for (final page in pages) ...page.characters],
      hasMore: pages.last.info.next != null,
      pageCount: pages.length,
    ),
  );

  void _onError(Object error) {
    final type = error is AppException ? error.type : AppErrorType.generic;
    final state = this.state;
    emit(
      state is CharactersSuccess
          ? state.copyWith(isLoadingMore: false, pageError: type)
          : CharactersState.error(filter: state.filter, error: type),
    );
  }
}
