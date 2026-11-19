import 'package:flutter_test/flutter_test.dart';

import '../pages/character_details_page.dart';
import '../pages/characters_page.dart';

// From the Characters tab: opens the character, favorites it, comes back.
Future<void> addFavorite(WidgetTester tester, String id) async {
  final characters = CharactersPage(tester);
  final details = CharacterDetailsPage(tester);
  await characters.openCharacter(id);
  await details.checkScreenIsDisplayed();
  await details.toggleFavorite();
  await details.checkIsFavorite(true);
  await details.goBack();
  await characters.checkScreenIsDisplayed();
}
