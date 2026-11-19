import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';

class CharactersRepository {
  final GraphQLClient _client;

  const CharactersRepository(this._client);

  Stream<CharactersPage> watchCharacters({
    required int page,
    CharactersFilter filter = const CharactersFilter(),
  }) => _client.watchStream(
    document: CharacterQueries.list,
    variables: {
      'page': page,
      'filter': {'name': ?filter.name, 'status': ?filter.status?.name},
    },
    parse: (data) => CharactersPage.fromJson(data['characters'] as JsonMap),
  );

  // An unknown id comes back as null: reported as notFound.
  Stream<CharacterDetails> watchCharacter(String id) => _client.watchStream(
    document: CharacterQueries.details,
    variables: {'id': id},
    parse: (data) => switch (data['character']) {
      final JsonMap character => CharacterDetails.fromJson(character),
      _ => throw const AppException(.notFound),
    },
  );

  // No ids, no request. Ids the API doesn't know are left out.
  Stream<List<Character>> watchCharactersByIds(List<String> ids) => ids.isEmpty
      ? Stream.value(const [])
      : _client.watchStream(
          document: CharacterQueries.byIds,
          variables: {'ids': ids},
          parse: (data) => [
            for (final json
                in data['charactersByIds'] as List<Object?>? ?? const [])
              if (json case final JsonMap character)
                Character.fromJson(character),
          ],
        );
}
