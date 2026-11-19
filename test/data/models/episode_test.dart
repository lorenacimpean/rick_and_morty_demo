import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';

import '../../mocks/mock_objects.dart';

void main() {
  group('Episode.fromJson', () {
    test('maps episode to code and air_date to airDate', () {
      // Act
      final episode = Episode.fromJson(MockObjects.episodeJsonMaximal);

      // Assert
      expect(episode, MockObjects.episodeMaximal);
    });

    test('fills missing fields with defaults', () {
      // Act
      final episode = Episode.fromJson(MockObjects.episodeJsonMinimal);

      // Assert
      expect(episode, MockObjects.episodeMinimal);
    });
  });
}
