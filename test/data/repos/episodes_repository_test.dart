import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/data/graphql/episode_queries.dart';
import 'package:rick_and_morty_demo/data/repos/episodes_repository.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockGraphQLClient client;
  late MockObservableQuery query;
  late EpisodesRepository repository;

  setUpAll(
    () => registerFallbackValue(
      WatchQueryOptions<Object?>(document: EpisodeQueries.list),
    ),
  );

  setUp(() {
    client = MockGraphQLClient();
    query = MockObservableQuery();
    repository = EpisodesRepository(client);
    when(() => client.watchQuery<Object?>(any())).thenReturn(query);
    when(() => query.close()).thenAnswer((_) async => QueryLifecycle.closed);
    when(() => query.stream).thenAnswer(
      (_) => Stream.value(
        MockObjects.result(data: {'episodes': MockObjects.episodesJsonMaximal}),
      ),
    );
  });

  group('watchEpisodes', () {
    test('emits the page parsed from the response', () async {
      // Act
      final stream = repository.watchEpisodes(page: 1);

      // Assert
      await expectLater(stream, emits(MockObjects.episodesPageMaximal));
      verify(() => client.watchQuery<Object?>(any())).called(1);
    });

    test('sends the page', () async {
      // Act
      await repository.watchEpisodes(page: 2).drain<void>();

      // Assert
      final options =
          verify(() => client.watchQuery<Object?>(captureAny())).captured.single
              as WatchQueryOptions<Object?>;
      expect(options.variables, {'page': 2});
    });
  });
}
