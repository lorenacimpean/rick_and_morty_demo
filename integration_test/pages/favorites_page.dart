import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

import 'base_page.dart';

class FavoritesPage extends BasePage {
  const FavoritesPage(super.tester);

  // Finders

  Finder get _screen => find.byKey(AppKeys.favorites.screen);

  Finder get _grid => find.byKey(AppKeys.favorites.grid);

  Finder get _empty => find.byKey(AppKeys.favorites.empty);

  Finder get _error => find.byKey(AppKeys.favorites.error);

  Finder get _retry => find.byKey(AppKeys.feedback.retry);

  Finder _card(String id) => find.byKey(AppKeys.cards.character(id));

  // Actions

  Future<void> openCharacter(String id) async {
    await waitFor(_card(id));
    await scrollUntilFound(_card(id), scrollable: _grid);
    await tapAndSettle(_card(id));
  }

  Future<void> retry() => tapAndPump(_retry);

  // Checks

  @override
  Future<void> checkScreenIsDisplayed() async {
    await waitFor(_screen);
    expect(_screen, findsOneWidget);
  }

  Future<void> checkCharacterShown(String id) async {
    await waitFor(_card(id));
    expect(_card(id), findsOneWidget);
  }

  Future<void> checkCharacterNotShown(String id) async {
    await waitUntilGone(_card(id));
    expect(_card(id), findsNothing);
  }

  Future<void> checkEmptyShown() async {
    await waitFor(_empty);
    expect(_empty, findsOneWidget);
  }

  Future<void> checkErrorShown() async {
    await waitFor(_error);
    expect(_error, findsOneWidget);
  }
}
