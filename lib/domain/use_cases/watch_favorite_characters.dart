import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/data/repos/favorites_repository.dart';
import 'package:rxdart/rxdart.dart';

// The favorite characters, updated whenever a favorite is added or removed.
class WatchFavoriteCharacters {
  final FavoritesRepository _favorites;
  final CharactersRepository _characters;

  const WatchFavoriteCharacters(this._favorites, this._characters);

  // Sorted ids: the same favorites always make the same, cached, query.
  Stream<List<Character>> call() => _favorites.watchIds().switchMap(
    (ids) => _characters.watchCharactersByIds(ids.toList()..sort()),
  );
}
