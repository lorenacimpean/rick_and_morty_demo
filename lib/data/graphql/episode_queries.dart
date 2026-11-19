import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/data/graphql/fragments.dart';

abstract final class EpisodeQueries {
  static final list = gql(_kList + kEpisodeSummaryFragment);
}

// Raw string: GraphQL variables start with $.
const _kList = r'''
query Episodes($page: Int) {
  episodes(page: $page) {
    info {
      pages
      next
    }
    results {
      ...EpisodeSummary
    }
  }
}
''';
