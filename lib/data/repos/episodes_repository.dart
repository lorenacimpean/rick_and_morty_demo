import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/episode_queries.dart';
import 'package:rick_and_morty_demo/data/models/episodes_page.dart';

class EpisodesRepository {
  final GraphQLClient _client;

  const EpisodesRepository(this._client);

  Stream<EpisodesPage> watchEpisodes({required int page}) =>
      _client.watchStream(
        document: EpisodeQueries.list,
        variables: {'page': page},
        parse: (data) => EpisodesPage.fromJson(data['episodes'] as JsonMap),
      );
}
