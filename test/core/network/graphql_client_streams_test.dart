import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockGraphQLClient client;
  late MockObservableQuery query;

  setUpAll(
    () => registerFallbackValue(
      WatchQueryOptions<Object?>(document: CharacterQueries.list),
    ),
  );

  setUp(() {
    client = MockGraphQLClient();
    query = MockObservableQuery();
    when(() => client.watchQuery<Object?>(any())).thenReturn(query);
    when(() => query.close()).thenAnswer((_) async => QueryLifecycle.closed);
  });

  void stubResults(List<QueryResult<Object?>> results) =>
      when(() => query.stream).thenAnswer((_) => Stream.fromIterable(results));

  Stream<JsonMap> watch({JsonMap variables = const {}}) => client.watchStream(
    document: CharacterQueries.list,
    variables: variables,
    parse: (data) => data,
  );

  group('watchStream', () {
    test('emits the parsed data of each result', () async {
      // Arrange
      stubResults([
        MockObjects.result(data: MockObjects.charactersJsonMinimal),
        MockObjects.result(data: MockObjects.charactersJsonMaximal),
      ]);

      // Act
      final stream = watch();

      // Assert
      await expectLater(
        stream,
        emitsInOrder([
          MockObjects.charactersJsonMinimal,
          MockObjects.charactersJsonMaximal,
          emitsDone,
        ]),
      );
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('skips results that are loading with no data', () async {
      // Arrange
      stubResults([
        MockObjects.loading(),
        MockObjects.result(data: MockObjects.charactersJsonMaximal),
      ]);

      // Act
      final stream = watch();

      // Assert
      await expectLater(
        stream,
        emitsInOrder([MockObjects.charactersJsonMaximal, emitsDone]),
      );
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('emits an AppException when a result failed', () async {
      // Arrange
      final exception = OperationException(
        linkException: NetworkException(
          originalException: const SocketException('offline'),
          uri: null,
        ),
      );
      stubResults([MockObjects.result(exception: exception)]);

      // Act
      final stream = watch();

      // Assert
      await expectLater(
        stream,
        emitsError(
          isA<AppException>().having(
            (error) => error.type,
            'type',
            AppErrorType.noConnection,
          ),
        ),
      );
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('watches the document with the variables', () async {
      // Arrange
      stubResults([]);

      // Act
      await watch(variables: {'page': 1}).drain<void>();

      // Assert
      final options =
          verify(() => client.watchQuery<Object?>(captureAny())).captured.single
              as WatchQueryOptions<Object?>;
      // having() compares maps by content; a record would compare them by identity.
      expect(
        options,
        isA<WatchQueryOptions<Object?>>()
            .having((o) => o.document, 'document', CharacterQueries.list)
            .having((o) => o.variables, 'variables', {'page': 1})
            .having((o) => o.fetchResults, 'fetchResults', isTrue),
      );
    });

    test('closes the query when the subscription is cancelled', () async {
      // Arrange
      when(() => query.stream).thenAnswer((_) => const Stream.empty());
      final subscription = watch().listen(null);

      // Act
      await subscription.cancel();

      // Assert
      verify(() => query.close()).called(1);
    });
  });
}
