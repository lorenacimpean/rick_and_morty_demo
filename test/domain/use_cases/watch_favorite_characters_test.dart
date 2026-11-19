import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_favorite_characters.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  const rick = MockObjects.characterMaximal;
  const morty = Character(id: '2', name: 'Morty Smith');

  late MockFavoritesRepository favorites;
  late MockCharactersRepository characters;
  late WatchFavoriteCharacters watchFavoriteCharacters;

  setUp(() {
    favorites = MockFavoritesRepository();
    characters = MockCharactersRepository();
    watchFavoriteCharacters = WatchFavoriteCharacters(favorites, characters);
  });

  group('call', () {
    test('watches the favorite ids, sorted', () async {
      // Arrange
      when(() => favorites.watchIds())
          .thenAnswer((_) => Stream.value({'2', '1'}));
      when(() => characters.watchCharactersByIds(['1', '2']))
          .thenAnswer((_) => Stream.value(const [rick, morty]));

      // Act
      final stream = watchFavoriteCharacters();

      // Assert
      await expectLater(stream, emits(const [rick, morty]));
      verify(() => characters.watchCharactersByIds(['1', '2'])).called(1);
    });

    test('follows the favorites when they change', () async {
      // Arrange
      when(() => favorites.watchIds()).thenAnswer(
        (_) => Stream.fromIterable([
          {'1'},
          <String>{},
        ]),
      );
      when(() => characters.watchCharactersByIds(['1']))
          .thenAnswer((_) => Stream.value(const [rick]));
      when(() => characters.watchCharactersByIds([]))
          .thenAnswer((_) => Stream.value(const []));

      // Act
      final stream = watchFavoriteCharacters();

      // Assert
      await expectLater(
        stream,
        emitsInOrder([
          const [rick],
          const <Character>[],
        ]),
      );
      verify(() => characters.watchCharactersByIds([])).called(1);
    });
  });
}
