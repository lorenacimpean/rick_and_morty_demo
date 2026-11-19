// Field sets shared by several queries. Append them to a query string.

// One character card.
const kCharacterSummaryFragment = '''
fragment CharacterSummary on Character {
  id
  name
  status
  species
  image
}
''';

// One episode row.
const kEpisodeSummaryFragment = '''
fragment EpisodeSummary on Episode {
  id
  name
  episode
  air_date
}
''';
