import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockObservableQuery extends Mock implements ObservableQuery<Object?> {}
