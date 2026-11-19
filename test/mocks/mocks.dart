import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/data/repos/episodes_repository.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_episodes_by_season.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockObservableQuery extends Mock implements ObservableQuery<Object?> {}

class MockCharactersRepository extends Mock implements CharactersRepository {}

class MockEpisodesRepository extends Mock implements EpisodesRepository {}

class MockWatchEpisodesBySeason extends Mock implements WatchEpisodesBySeason {}
