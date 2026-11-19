// Real API data that doesn't change.
abstract final class TestData {
  static const kRickId = '1';
  static const kRickName = 'Rick Sanchez';
  // Matches more than a page, dead ones included.
  static const kRickSearch = 'Rick';
  static const kMortyId = '2';
  static const kMortyName = 'Morty Smith';
  static const kSummerId = '3';
  static const kSummerName = 'Summer Smith';
  // Pages hold 20 characters, ordered by id.
  static const kFirstOfPage2Id = '21';

  static const kFirstEpisode = 'S01E01';
  static const kSecondEpisode = 'S01E02';
  static const kFirstOfSeason2 = 'S02E01';
  static const kLastEpisode = 'S05E10';

  static const kNoMatch = 'zzzzzz';
  static const kBlank = '   ';
}
