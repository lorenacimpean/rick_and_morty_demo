import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

import '../../mocks/mock_objects.dart';

void main() {
  group('Character.fromJson', () {
    test('reads every field and maps image to imageUrl', () {
      // Act
      final character = Character.fromJson(MockObjects.characterJsonMaximal);

      // Assert
      expect(character, MockObjects.characterMaximal);
    });

    test('fills missing fields with defaults', () {
      // Act
      final character = Character.fromJson(MockObjects.characterJsonMinimal);

      // Assert
      expect(character, MockObjects.characterMinimal);
    });

    test('fails without an id', () {
      // Act
      Character parse() => Character.fromJson(const {'name': 'No id'});

      // Assert
      expect(parse, throwsA(isA<TypeError>()));
    });

    test('reads "Dead" as dead', () {
      // Act
      final character = Character.fromJson(const {'id': '1', 'status': 'Dead'});

      // Assert
      expect(character.status, CharacterStatus.dead);
    });

    test('reads "unknown" as unknown', () {
      // Act
      final character = Character.fromJson(const {
        'id': '1',
        'status': 'unknown',
      });

      // Assert
      expect(character.status, CharacterStatus.unknown);
    });

    test('reads an unexpected status as unknown', () {
      // Act
      final character = Character.fromJson(const {
        'id': '1',
        'status': 'Zombie',
      });

      // Assert
      expect(character.status, CharacterStatus.unknown);
    });
  });
}
