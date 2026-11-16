import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_streams.dart';
import 'package:rick_and_morty_demo/data/graphql/character_queries.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockGraphQLClient client;
  late MockObservableQuery query;
  late CharactersRepository repository;

  setUpAll(
    () => registerFallbackValue(
      WatchQueryOptions<Object?>(document: CharacterQueries.list),
    ),
  );

  setUp(() {
    client = MockGraphQLClient();
    query = MockObservableQuery();
    repository = CharactersRepository(client);
    when(() => client.watchQuery<Object?>(any())).thenReturn(query);
    when(() => query.close()).thenAnswer((_) async => QueryLifecycle.closed);
  });

  void stubData(JsonMap? characters) => when(() => query.stream).thenAnswer(
    (_) => Stream.value(MockObjects.result(data: {'characters': characters})),
  );

  JsonMap sentVariables() {
    final captured = verify(() => client.watchQuery<Object?>(captureAny()))
        .captured;
    return (captured.single as WatchQueryOptions<Object?>).variables;
  }

  group('watchCharacters', () {
    test('emits the page parsed from the response', () async {
      // Arrange
      stubData(MockObjects.charactersJsonMaximal);

      // Act
      final stream = repository.watchCharacters(page: 1);

      // Assert
      await expectLater(stream, emits(MockObjects.charactersPageMaximal));
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('emits an empty page when nothing matches', () async {
      // Arrange
      stubData(MockObjects.charactersJsonMinimal);

      // Act
      final stream = repository.watchCharacters(page: 1);

      // Assert
      await expectLater(stream, emits(MockObjects.charactersPageMinimal));
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('sends the page, name and status', () async {
      // Arrange
      stubData(MockObjects.charactersJsonMinimal);

      // Act
      await repository
          .watchCharacters(
            page: 2,
            filter: const CharactersFilter(name: 'Rick', status: .alive),
          )
          .drain<void>();

      // Assert
      expect(sentVariables(), {
        'page': 2,
        'filter': {'name': 'Rick', 'status': 'alive'},
      });
    });

    test('leaves unset filter fields out', () async {
      // Arrange
      stubData(MockObjects.charactersJsonMinimal);

      // Act
      await repository.watchCharacters(page: 1).drain<void>();

      // Assert
      expect(sentVariables(), {'page': 1, 'filter': <String, Object?>{}});
    });
  });
}
