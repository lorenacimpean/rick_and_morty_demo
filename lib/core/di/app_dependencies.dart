import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_factory.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/data/repos/episodes_repository.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_episodes_by_season.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_view_model.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_view_model.dart';

final getIt = GetIt.instance;

abstract final class AppDependencies {
  static Future<void> register() async {
    getIt
      ..registerSingleton<GraphQLClient>(await GraphQLClientFactory.create())
      ..registerLazySingleton(() => CharactersRepository(getIt()))
      ..registerLazySingleton(() => EpisodesRepository(getIt()))
      ..registerLazySingleton(() => WatchEpisodesBySeason(getIt()))
      // A new view model each time its screen opens.
      ..registerFactory(() => CharactersViewModel(getIt()))
      ..registerFactory(() => EpisodesViewModel(getIt()))
      // The character id comes from the route: getIt<…>(param1: id).
      ..registerFactoryParam<CharacterDetailsViewModel, String, void>(
        (id, _) => CharacterDetailsViewModel(getIt(), id),
      );
  }
}
