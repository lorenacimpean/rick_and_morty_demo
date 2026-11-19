import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';

import '../../mocks/mock_objects.dart';

void main() {
  group('CharacterDetails.fromJson', () {
    test('reads every field, nested places and episodes', () {
      // Act
      final details = CharacterDetails.fromJson(
        MockObjects.characterDetailsJsonMaximal,
      );

      // Assert
      expect(details, MockObjects.characterDetailsMaximal);
    });

    test('fills missing fields with defaults', () {
      // Act
      final details = CharacterDetails.fromJson(
        MockObjects.characterDetailsJsonMinimal,
      );

      // Assert
      expect(details, MockObjects.characterDetailsMinimal);
    });

    test('reads a place without a name as an empty place', () {
      // Act
      final details = CharacterDetails.fromJson(const {
        'id': '1',
        'origin': <String, Object?>{},
      });

      // Assert
      expect(details.origin, MockObjects.placeMinimal);
    });
  });
}
