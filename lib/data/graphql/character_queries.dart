import 'package:graphql/client.dart';

abstract final class CharacterQueries {
  static final list = gql(_kList + _kCharacterSummary);
}

// Raw strings: GraphQL variables start with $.
const _kList = r'''
query Characters($page: Int, $filter: FilterCharacter) {
  characters(page: $page, filter: $filter) {
    info {
      next
    }
    results {
      ...CharacterSummary
    }
  }
}
''';

// Fields of one character card. Shared by every query that lists characters.
const _kCharacterSummary = '''
fragment CharacterSummary on Character {
  id
  name
  status
  species
  image
}
''';
