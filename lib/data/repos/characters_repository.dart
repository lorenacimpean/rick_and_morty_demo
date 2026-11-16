import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';
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
}
