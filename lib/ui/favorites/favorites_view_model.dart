import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_favorite_characters.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_state.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesViewModel extends AppCubit<FavoritesState> {
  final WatchFavoriteCharacters _watchFavoriteCharacters;
  final PublishSubject<void> _loads;

  FavoritesViewModel(WatchFavoriteCharacters watchFavoriteCharacters)
    : this._(watchFavoriteCharacters, PublishSubject());

  // Private so the subject can be handed to AppCubit, which closes it.
  FavoritesViewModel._(this._watchFavoriteCharacters, this._loads)
    : super(const FavoritesState.loading(), subjects: [_loads]);

  @override
  void init() {
    // switchMap stops the failed watch when retry starts a new one.
    listenTo(
      _loads.switchMap((_) => _watchFavoriteCharacters()),
      _onCharacters,
      onError: _onError,
    );
    _loads.add(null);
  }

  void retry() {
    emit(const FavoritesState.loading());
    _loads.add(null);
  }

  void _onCharacters(List<Character> characters) =>
      emit(FavoritesState.success(characters));

  void _onError(Object error) => emit(
    FavoritesState.error(
      error is AppException ? error.type : AppErrorType.generic,
    ),
  );
}
