import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/data/graphql/fragments.dart';

abstract final class CharacterQueries {
  static final list = gql(_kList + kCharacterSummaryFragment);
  static final details = gql(
    _kDetails + kCharacterSummaryFragment + kEpisodeSummaryFragment,
  );
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

// Three levels deep at most: the API rejects deeper queries.
const _kDetails = r'''
query Character($id: ID!) {
  character(id: $id) {
    ...CharacterSummary
    type
    gender
    origin {
      name
    }
    location {
      name
    }
    episode {
      ...EpisodeSummary
    }
  }
}
''';
