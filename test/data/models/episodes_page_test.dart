import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/data/models/episodes_page.dart';

import '../../mocks/mock_objects.dart';

void main() {
  group('EpisodesPage.fromJson', () {
    test('reads the results, the next page and the page count', () {
      // Act
      final page = EpisodesPage.fromJson(MockObjects.episodesJsonMaximal);

      // Assert
      expect(page, MockObjects.episodesPageMaximal);
    });

    test('is empty with one page when info and results are missing', () {
      // Act
      final page = EpisodesPage.fromJson(MockObjects.episodesJsonMinimal);

      // Assert
      expect(page, MockObjects.episodesPageMinimal);
    });
  });
}
