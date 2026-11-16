import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/data/models/characters_page.dart';

import '../../mocks/mock_objects.dart';

void main() {
  group('CharactersPage.fromJson', () {
    test('reads the results and the next page', () {
      // Act
      final page = CharactersPage.fromJson(MockObjects.charactersJsonMaximal);

      // Assert
      expect(page, MockObjects.charactersPageMaximal);
    });

    test('is empty with no next page when info and results are missing', () {
      // Act
      final page = CharactersPage.fromJson(MockObjects.charactersJsonMinimal);

      // Assert
      expect(page, MockObjects.charactersPageMinimal);
    });

    test('has no next page on the last page', () {
      // Act
      final page = CharactersPage.fromJson(const {
        'info': {'next': null},
        'results': <Object?>[],
      });

      // Assert
      expect(page.info.next, isNull);
    });
  });
}
