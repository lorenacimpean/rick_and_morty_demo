import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';
import 'package:rick_and_morty_demo/data/models/page_info.dart';

abstract final class MockObjects {
  static const kImageUrl =
      'https://rickandmortyapi.com/api/character/avatar/1.jpeg';

  // Models

  static const characterMinimal = Character(id: '1');

  static const characterMaximal = Character(
    id: '1',
    name: 'Rick Sanchez',
    status: .alive,
    species: 'Human',
    imageUrl: kImageUrl,
  );

  static const charactersPageMinimal = CharactersPage();

  static const charactersPageMaximal = CharactersPage(
    characters: [characterMaximal],
    info: PageInfo(next: 2),
  );

  // A second page with no page after it.
  static const charactersPageLast = CharactersPage(
    characters: [Character(id: '2', name: 'Morty Smith', status: .alive)],
  );

  // API JSON

  static const JsonMap characterJsonMinimal = {'id': '1'};

  static const JsonMap characterJsonMaximal = {
    'id': '1',
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'image': kImageUrl,
  };

  static const JsonMap charactersJsonMinimal = {};

  static const JsonMap charactersJsonMaximal = {
    'info': {'next': 2},
    'results': [characterJsonMaximal],
  };

  // Query results

  static QueryResult<Object?> result({
    JsonMap? data,
    OperationException? exception,
  }) => QueryResult(
    options: WatchQueryOptions(document: CharacterQueries.list),
    data: data,
    exception: exception,
    source: .network,
  );

  static QueryResult<Object?> loading() => QueryResult.loading(
    options: WatchQueryOptions(document: CharacterQueries.list),
  );
}
