import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';

abstract final class GraphQLClientFactory {
  static const _kEndpoint = 'https://rickandmortyapi.com/graphql';

  static Future<GraphQLClient> create() async {
    final directory = await getApplicationSupportDirectory();
    final store = await HiveStore.open(path: directory.path);
    return GraphQLClient(
      link: HttpLink(_kEndpoint),
      cache: GraphQLCache(store: store),
      // Watched queries emit the cached result first, then the network one.
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(fetch: .cacheAndNetwork),
      ),
    );
  }
}
