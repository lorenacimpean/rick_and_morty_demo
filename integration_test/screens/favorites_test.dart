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
    testWidgets('opens from the Characters tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);

      // Act
      await shell.openTab(.favorites);

      // Assert
      await FavoritesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.favorites);
    });

    testWidgets('opens from the Episodes tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);
      await EpisodesPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.favorites);

      // Assert
      await FavoritesPage(tester).checkScreenIsDisplayed();
    });

    testWidgets('opens details from a card', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await AppShellPage(tester).openTab(.favorites);

      // Act
      await FavoritesPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkName(TestData.kRickName);
    });

    testWidgets('comes back from details with the back button', (tester) async {
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
      await favorites.checkCharacterShown(TestData.kRickId);
    });

    testWidgets('comes back from details when its tab is tapped again', (
      tester,
    ) async {
      // Arrange
      final shell = AppShellPage(tester);
      final favorites = FavoritesPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await shell.openTab(.favorites);
      await favorites.openCharacter(TestData.kRickId);
      await CharacterDetailsPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.favorites);

      // Assert
      await favorites.checkScreenIsDisplayed();
    });

    testWidgets('opens the Characters tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.favorites);

      // Act
      await shell.openTab(.characters);

      // Assert
      await CharactersPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.characters);
    });
  });

  group('positive', () {
    testWidgets('shows a new favorite', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);

      // Act
      await AppShellPage(tester).openTab(.favorites);

      // Assert
      await favorites.checkCharacterShown(TestData.kRickId);
    });
  });

  group('negative', () {
    testWidgets('shows the empty state with no favorites', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      await TestApp.start(tester);

      // Act
      await AppShellPage(tester).openTab(.favorites);

      // Assert
      await favorites.checkEmptyShown();
    });

    testWidgets('shows an error when offline', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      final app = await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      app.goOffline();

      // Act
      await AppShellPage(tester).openTab(.favorites);

      // Assert
      await favorites.checkErrorShown();
    });

    testWidgets('recovers when retried back online', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      final app = await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      app.goOffline();
      await AppShellPage(tester).openTab(.favorites);
      await favorites.checkErrorShown();
      app.goOnline();

      // Act
      await favorites.retry();

      // Assert
      await favorites.checkCharacterShown(TestData.kRickId);
    });
  });

  group('limit', () {
    testWidgets('shows several favorites', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await addFavorite(tester, TestData.kMortyId);
      await addFavorite(tester, TestData.kSummerId);

      // Act
      await AppShellPage(tester).openTab(.favorites);

      // Assert
      await favorites.checkCharacterShown(TestData.kRickId);
      await favorites.checkCharacterShown(TestData.kMortyId);
      await favorites.checkCharacterShown(TestData.kSummerId);
    });
  });

  group('edge', () {
    testWidgets('drops a favorite removed in details', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);
      await AppShellPage(tester).openTab(.favorites);
      await favorites.openCharacter(TestData.kRickId);
      await details.toggleFavorite();
      await details.checkIsFavorite(false);

      // Act
      await details.goBack();

      // Assert
      await favorites.checkCharacterNotShown(TestData.kRickId);
      await favorites.checkEmptyShown();
    });

    testWidgets('keeps favorites after a restart', (tester) async {
      // Arrange
      final favorites = FavoritesPage(tester);
      final app = await TestApp.start(tester);
      await addFavorite(tester, TestData.kRickId);

      // Act
      await app.restart();
      await AppShellPage(tester).openTab(.favorites);

      // Assert
      await favorites.checkCharacterShown(TestData.kRickId);
    });
  });
}
