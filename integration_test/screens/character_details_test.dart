import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/flows.dart';
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
    testWidgets('opens from a card on the Characters tab', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);

      // Act
      await CharactersPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkName(TestData.kRickName);
    });

    testWidgets('opens from a card on the Favorites tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await shell.openTab(.favorites);

      // Act
      await FavoritesPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkName(TestData.kRickName);
      shell.checkSelectedTab(.favorites);
    });

    testWidgets('goes back to Characters when opened there', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await characters.openCharacter(TestData.kRickId);
      await details.checkScreenIsDisplayed();

      // Act
      await details.goBack();

      // Assert
      await characters.checkScreenIsDisplayed();
    });

    testWidgets('goes back to Favorites when opened there', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await AppShellPage(tester).openTab(.favorites);
      await favorites.openCharacter(TestData.kRickId);
      await details.checkScreenIsDisplayed();

      // Act
      await details.goBack();

      // Assert
      await favorites.checkScreenIsDisplayed();
    });

    testWidgets('opens another tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await CharactersPage(tester).openCharacter(TestData.kRickId);
      await CharacterDetailsPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.episodes);

      // Assert
      await EpisodesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.episodes);
    });

    testWidgets('is still open after visiting another tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await CharactersPage(tester).openCharacter(TestData.kRickId);
      await details.checkScreenIsDisplayed();
      await shell.openTab(.episodes);
      await EpisodesPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.characters);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkName(TestData.kRickName);
    });
  });

  group('positive', () {
    testWidgets("shows the character's details", (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);

      // Act
      await CharactersPage(tester).openCharacter(TestData.kMortyId);

      // Assert
      await details.checkName(TestData.kMortyName);
      await details.checkIsFavorite(false);
    });

    testWidgets('adds the character to favorites', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await CharactersPage(tester).openCharacter(TestData.kRickId);
      await details.checkIsFavorite(false);

      // Act
      await details.toggleFavorite();

      // Assert
      await details.checkIsFavorite(true);
    });

    testWidgets('removes the character from favorites', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await CharactersPage(tester).openCharacter(TestData.kRickId);
      await details.toggleFavorite();
      await details.checkIsFavorite(true);

      // Act
      await details.toggleFavorite();

      // Assert
      await details.checkIsFavorite(false);
    });
  });

  group('negative', () {
    testWidgets('shows an error when offline', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final app = await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);
      app.goOffline();

      // Act
      await characters.openCharacter(TestData.kRickId);

      // Assert
      await CharacterDetailsPage(tester).checkErrorShown();
    });

    testWidgets('recovers when retried back online', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final details = CharacterDetailsPage(tester);
      final app = await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);
      app.goOffline();
      await characters.openCharacter(TestData.kRickId);
      await details.checkErrorShown();
      app.goOnline();

      // Act
      await details.retry();

      // Assert
      await details.checkName(TestData.kRickName);
    });
  });

  group('limit', () {
    testWidgets('opens a character from the next page', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);

      // Act
      await CharactersPage(tester).openCharacter(TestData.kFirstOfPage2Id);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkIsFavorite(false);
    });
  });

  group('edge', () {
    testWidgets('remembers the favorite when opened again', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);

      // Act
      await CharactersPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkIsFavorite(true);
    });

    testWidgets('shows the favorite from the other tab', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await AppShellPage(tester).openTab(.favorites);

      // Act
      await FavoritesPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkIsFavorite(true);
    });
  });
}
