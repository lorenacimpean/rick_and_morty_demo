import 'package:gql/ast.dart';
import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rxdart/rxdart.dart';

typedef JsonMap = Map<String, Object?>;

extension GraphQLClientStreams on GraphQLClient {
  // Emits the cached result, then the network one. Cancelling closes the query.
  Stream<T> watchStream<T extends Object>({
    required DocumentNode document,
    required T Function(JsonMap data) parse,
    JsonMap variables = const {},
  }) => Rx.using<QueryResult<Object?>, ObservableQuery<Object?>>(
    resourceFactory: () => watchQuery(
      WatchQueryOptions(
        document: document,
        variables: variables,
        fetchResults: true,
      ),
    ),
    streamFactory: (query) => query.stream,
    disposer: (query) => query.close(),
  ).mapNotNull((result) => _parse(result, parse));
}

// Null while loading with nothing cached yet. Failures become AppExceptions.
T? _parse<T>(QueryResult<Object?> result, T Function(JsonMap data) parse) {
  if (result.exception case final exception?) {
    throw AppException.fromOperation(exception);
  }
  return switch (result.data) {
    final data? => parse(data),
    null => null,
  };
}
