import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_factory.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';

final getIt = GetIt.instance;

abstract final class AppDependencies {
  static Future<void> register() async {
    getIt
      ..registerSingleton<GraphQLClient>(await GraphQLClientFactory.create())
      ..registerLazySingleton(() => CharactersRepository(getIt()))
      // A new view model each time its screen opens.
      ..registerFactory(() => CharactersViewModel(getIt()));
  }
}
