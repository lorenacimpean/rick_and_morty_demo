import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockObservableQuery extends Mock implements ObservableQuery<Object?> {}

class MockCharactersRepository extends Mock implements CharactersRepository {}
