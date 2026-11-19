import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/episodes_page.dart';
import 'package:rick_and_morty_demo/data/models/page_info.dart';
import 'package:rick_and_morty_demo/data/models/place.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';

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

  static const episodeMinimal = Episode(id: '1');

  static const episodeMaximal = Episode(
    id: '1',
    name: 'Pilot',
    code: 'S01E01',
    airDate: 'December 2, 2013',
  );

  static const placeMinimal = Place();

  static const placeMaximal = Place(name: 'Earth (C-137)');

  static const characterDetailsMinimal = CharacterDetails(id: '1');

  static const characterDetailsMaximal = CharacterDetails(
    id: '1',
    name: 'Rick Sanchez',
    status: .alive,
    species: 'Human',
    type: 'Genius',
    gender: 'Male',
    imageUrl: kImageUrl,
    origin: placeMaximal,
    location: Place(name: 'Citadel of Ricks'),
    episodes: [episodeMaximal],
  );

  static const episodesPageMinimal = EpisodesPage();

  static const episodesPageMaximal = EpisodesPage(
    episodes: [episodeMaximal],
    info: PageInfo(next: 2, pages: 3),
  );

  static const seasonMinimal = Season(number: 0, episodes: []);

  static const seasonMaximal = Season(number: 1, episodes: [episodeMaximal]);

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

  static const JsonMap episodeJsonMinimal = {'id': '1'};

  static const JsonMap episodeJsonMaximal = {
    'id': '1',
    'name': 'Pilot',
    'episode': 'S01E01',
    'air_date': 'December 2, 2013',
  };

  static const JsonMap characterDetailsJsonMinimal = {'id': '1'};

  static const JsonMap characterDetailsJsonMaximal = {
    ...characterJsonMaximal,
    'type': 'Genius',
    'gender': 'Male',
    'origin': {'name': 'Earth (C-137)'},
    'location': {'name': 'Citadel of Ricks'},
    'episode': [episodeJsonMaximal],
  };

  static const JsonMap episodesJsonMinimal = {};

  static const JsonMap episodesJsonMaximal = {
    'info': {'next': 2, 'pages': 3},
    'results': [episodeJsonMaximal],
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
