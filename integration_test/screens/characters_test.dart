import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

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
    testWidgets('opens on app start', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final characters = CharactersPage(tester);

      // Act
      await TestApp.start(tester);

      // Assert
      await characters.checkScreenIsDisplayed();
      shell.checkSelectedTab(.characters);
    });

    testWidgets('opens from the Characters tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await shell.openTab(.episodes);
      await EpisodesPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.characters);

      // Assert
      await characters.checkScreenIsDisplayed();
      shell.checkSelectedTab(.characters);
    });

    testWidgets('opens details from a card', (tester) async {
      // Arrange
      final details = CharacterDetailsPage(tester);
      await TestApp.start(tester);

      // Act
      await CharactersPage(tester).openCharacter(TestData.kRickId);

      // Assert
      await details.checkScreenIsDisplayed();
      await details.checkName(TestData.kRickName);
    });

    testWidgets('comes back from details with the back button', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.openCharacter(TestData.kRickId);

      // Act
      await CharacterDetailsPage(tester).goBack();

      // Assert
      await characters.checkScreenIsDisplayed();
      await characters.checkCharacterShown(TestData.kRickId);
    });

    testWidgets('comes back from details when its tab is tapped again', (
      tester,
    ) async {
      // Arrange
      final shell = AppShellPage(tester);
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.openCharacter(TestData.kRickId);
      await CharacterDetailsPage(tester).checkScreenIsDisplayed();

      // Act
      await shell.openTab(.characters);

      // Assert
      await characters.checkScreenIsDisplayed();
    });

    testWidgets('opens the Episodes tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);

      // Act
      await shell.openTab(.episodes);

      // Assert
      await EpisodesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.episodes);
    });

    testWidgets('opens the Favorites tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      await TestApp.start(tester);

      // Act
      await shell.openTab(.favorites);

      // Assert
      await FavoritesPage(tester).checkScreenIsDisplayed();
      shell.checkSelectedTab(.favorites);
    });

    testWidgets('keeps the search after visiting another tab', (tester) async {
      // Arrange
      final shell = AppShellPage(tester);
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.searchFor(TestData.kMortyName);
      await characters.checkCharacterShown(TestData.kMortyId);
      await shell.openTab(.episodes);

      // Act
      await shell.openTab(.characters);

      // Assert
      await characters.checkCharacterShown(TestData.kMortyId);
      await characters.checkCharacterNotShown(TestData.kRickId);
    });
  });

  group('positive', () {
    testWidgets('shows the first page of characters', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);

      // Act
      await TestApp.start(tester);

      // Assert
      await characters.checkResultsShown();
      await characters.checkCharacterShown(TestData.kRickId);
      characters.checkStatusSelected(null);
    });

    testWidgets('finds characters by name', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);

      // Act
      await characters.searchFor(TestData.kMortyName);

      // Assert
      await characters.checkCharacterNotShown(TestData.kRickId);
      await characters.checkCharacterShown(TestData.kMortyId);
    });

    testWidgets('filters by status', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);

      // Act
      await characters.selectStatus(CharacterStatus.dead);

      // Assert
      characters.checkStatusSelected(CharacterStatus.dead);
      await characters.checkCharacterNotShown(TestData.kRickId);
      await characters.checkResultsShown();
    });

    testWidgets('shows everyone again when All is selected', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.selectStatus(CharacterStatus.dead);
      await characters.checkCharacterNotShown(TestData.kRickId);

      // Act
      await characters.selectStatus(null);

      // Assert
      characters.checkStatusSelected(null);
      await characters.checkCharacterShown(TestData.kRickId);
    });
  });

  group('negative', () {
    testWidgets('shows the empty state when nothing matches', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);

      // Act
      await characters.searchFor(TestData.kNoMatch);

      // Assert
      await characters.checkEmptyShown();
    });

    testWidgets('shows an error when offline', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);

      // Act
      await TestApp.start(tester, offline: true);

      // Assert
      await characters.checkErrorShown();
    });

    testWidgets('recovers when retried back online', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final app = await TestApp.start(tester, offline: true);
      await characters.checkErrorShown();
      app.goOnline();

      // Act
      await characters.retry();

      // Assert
      await characters.checkCharacterShown(TestData.kRickId);
    });
  });

  group('limit', () {
    testWidgets('loads the next page at the end of the list', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);

      // Act
      await characters.scrollToCharacter(TestData.kFirstOfPage2Id);

      // Assert
      await characters.checkCharacterShown(TestData.kFirstOfPage2Id);
    });

    testWidgets('keeps the list when the next page fails', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final app = await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);
      app.goOffline();

      // Act
      await characters.scrollToBottom();

      // Assert
      await characters.checkNextPageErrorShown();
      await characters.checkResultsShown();
    });

    testWidgets('loads the failed page when retried online', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      final app = await TestApp.start(tester);
      await characters.checkCharacterShown(TestData.kRickId);
      app.goOffline();
      await characters.scrollToBottom();
      await characters.checkNextPageErrorShown();
      app.goOnline();

      // Act
      await characters.retryNextPage();

      // Assert
      await characters.scrollToCharacter(TestData.kFirstOfPage2Id);
      await characters.checkCharacterShown(TestData.kFirstOfPage2Id);
    });

    testWidgets('loads no more when the results fit one page', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.searchFor(TestData.kSummerName);
      await characters.checkCharacterShown(TestData.kSummerId);

      // Act
      await characters.scrollToBottom();

      // Assert
      characters.checkNoNextPage();
    });
  });

  group('edge', () {
    testWidgets('treats a blank search as no search', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.searchFor(TestData.kMortyName);
      await characters.checkCharacterNotShown(TestData.kRickId);

      // Act
      await characters.searchFor(TestData.kBlank);

      // Assert
      await characters.checkCharacterShown(TestData.kRickId);
    });

    testWidgets('combines the search with the status', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.searchFor(TestData.kRickSearch);
      await characters.checkCharacterShown(TestData.kRickId);

      // Act
      await characters.selectStatus(CharacterStatus.dead);

      // Assert
      await characters.checkCharacterNotShown(TestData.kRickId);
      await characters.checkResultsShown();
    });

    testWidgets('keeps the status when searching', (tester) async {
      // Arrange
      final characters = CharactersPage(tester);
      await TestApp.start(tester);
      await characters.selectStatus(CharacterStatus.dead);

      // Act
      await characters.searchFor(TestData.kRickName);

      // Assert
      characters.checkStatusSelected(CharacterStatus.dead);
      await characters.checkCharacterNotShown(TestData.kRickId);
    });
  });
}
