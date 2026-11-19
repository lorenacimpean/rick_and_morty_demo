import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/data/repos/favorites_repository.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_state.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

class CharacterDetailsViewModel extends AppCubit<CharacterDetailsState> {
  final CharactersRepository _characters;
  final FavoritesRepository _favorites;
  final String _id;
  final PublishSubject<void> _loads;

  CharacterDetailsViewModel(
    CharactersRepository characters,
    FavoritesRepository favorites,
    String id,
  ) : this._(characters, favorites, id, PublishSubject());

  // Private so the subject can be handed to AppCubit, which closes it.
  CharacterDetailsViewModel._(
    this._characters,
    this._favorites,
    this._id,
    this._loads,
  ) : super(const CharacterDetailsState.loading(), subjects: [_loads]);

  @override
  void init() {
    // switchMap stops the failed watch when retry starts a new one.
    listenTo(
      _loads.switchMap((_) => _watchCharacter()),
      _onCharacter,
      onError: _onError,
    );
    _loads.add(null);
  }

  void retry() {
    emit(const CharacterDetailsState.loading());
    _loads.add(null);
  }

  Future<void> toggleFavorite() => _favorites.toggle(_id);

  // The character, and whether it's a favorite: emits when either changes.
  Stream<(CharacterDetails, bool)> _watchCharacter() => Rx.combineLatest2(
    _characters.watchCharacter(_id),
    _favorites.watchIds().map((ids) => ids.contains(_id)),
    (character, isFavorite) => (character, isFavorite),
  );

  void _onCharacter((CharacterDetails, bool) result) {
    final (character, isFavorite) = result;
    emit(CharacterDetailsState.success(character, isFavorite: isFavorite));
  }

  void _onError(Object error) => emit(
    CharacterDetailsState.error(
      error is AppException ? error.type : AppErrorType.generic,
    ),
  );
}
