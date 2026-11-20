import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app.dart';
import '../helpers/test_data.dart';
import '../pages/app_shell_page.dart';
import '../pages/character_details_page.dart';
import '../pages/characters_page.dart';
import '../pages/episodes_page.dart';
import '../pages/favorites_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('navigation', () {
    testWidgets('opens from the Characters tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);

      // Act
      await shell.openTab(.episodes);

      // Assert
      await EpisodesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.episodes);
    });

    testWidgets('opens from the Favorites tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.favorites);
      await FavoritesPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.episodes);

      // Assert
      await EpisodesPage(tester).checkScreenIsDisplayed();
    });

    testWidgets('opens from character details', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await CharactersPage(tester).openCharacter(TestData.kRickId);
      await CharacterDetailsPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.episodes);

      // Assert
      await EpisodesPage(tester).checkScreenIsDisplayed();
    });

    testWidgets('stays when its tab is tapped again', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);
      await episodes.checkSeasonShown(1);

      // Act
      await shell.openTab(.episodes);

      // Assert
      await episodes.checkScreenIsDisplayed();
      await episodes.checkSeasonShown(1);
    });

    testWidgets('opens the Characters tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);

      // Act
      await shell.openTab(.characters);

      // Assert
      await CharactersPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.characters);
    });

    testWidgets('opens the Favorites tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);

      // Act
      await shell.openTab(.favorites);

      // Assert
      await FavoritesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.favorites);
    });
  });

  group('positive', () {
    testWidgets('starts with the first season', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);

      // Act
      await AppShellPage(tester).openTab(.episodes);

      // Assert
      await episodes.checkSeasonShown(1);
      await episodes.checkEpisodeShown(TestData.kFirstEpisode);
    });

    testWidgets('sorts episodes within a season', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);

      // Act
      await AppShellPage(tester).openTab(.episodes);

      // Assert
      await episodes.checkEpisodesInOrder(
        TestData.kFirstEpisode,
        TestData.kSecondEpisode,
      );
    });

    testWidgets('groups the next season under its header', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);
      await AppShellPage(tester).openTab(.episodes);

      // Act
      await episodes.scrollToSeason(2);

      // Assert
      await episodes.checkSeasonShown(2);
      await episodes.scrollToEpisode(TestData.kFirstOfSeason2);
      await episodes.checkEpisodeShown(TestData.kFirstOfSeason2);
    });
  });

  group('negative', () {
    testWidgets('shows an error when offline', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester, offline: true);

      // Act
      await AppShellPage(tester).openTab(.episodes);

      // Assert
      await episodes.checkErrorShown();
    });

    testWidgets('recovers when retried back online', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      final app = await TestApp.start(tester, offline: true);
      await AppShellPage(tester).openTab(.episodes);
      await episodes.checkErrorShown();
      app.goOnline();

      // Act
      await episodes.retry();

      // Assert
      await episodes.checkSeasonShown(1);
    });
  });

  group('limit', () {
    testWidgets('reaches the last episode of the last season', (tester) async {
      // Arrange
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);
      await AppShellPage(tester).openTab(.episodes);

      // Act
      await episodes.scrollToEpisode(TestData.kLastEpisode);

      // Assert
      // Only the episode: its season header is scrolled away and no longer built.
      await episodes.checkEpisodeShown(TestData.kLastEpisode);
    });
  });

  group('edge', () {
    testWidgets('keeps the scroll position after visiting another tab', (
      tester,
    ) async {
      // Arrange
      final shell = AppShellPage(tester);
      final episodes = EpisodesPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);
      await episodes.scrollToEpisode(TestData.kLastEpisode);
      await shell.openTab(.characters);

      // Act
      await shell.openTab(.episodes);

      // Assert
      await episodes.checkEpisodeShown(TestData.kLastEpisode);
    });
  });
}
