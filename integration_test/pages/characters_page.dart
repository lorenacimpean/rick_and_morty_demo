import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

import 'base_page.dart';

class CharactersPage extends BasePage {
  const CharactersPage(super.tester);

  // Finders

  Finder get _screen => find.byKey(AppKeys.characters.screen);

  Finder get _searchField => find.byKey(AppKeys.characters.searchField);

  Finder get _grid => find.byKey(AppKeys.characters.grid);

  Finder get _empty => find.byKey(AppKeys.characters.empty);

  Finder get _error => find.byKey(AppKeys.characters.error);

  Finder get _retry => find.byKey(AppKeys.feedback.retry);

  Finder get _pagingLoading => find.byKey(AppKeys.characters.pagingLoading);

  Finder get _pagingError => find.byKey(AppKeys.characters.pagingError);

  Finder get _pagingRetry => find.byKey(AppKeys.feedback.pagingRetry);

  Finder _card(String id) => find.byKey(AppKeys.cards.character(id));

  Finder _statusChip(CharacterStatus? status) => find.byKey(switch (status) {
    null => AppKeys.characters.allChip,
    .alive => AppKeys.characters.aliveChip,
    .dead => AppKeys.characters.deadChip,
    .unknown => AppKeys.characters.unknownChip,
  });

  // Actions

  Future<void> searchFor(String text) async {
    await tester.enterText(_searchField, text);
    // Past the debounce, so the search has started.
    await tester.pump(CharactersViewModel.kSearchDebounce + BasePage.kFrame);
  }

  Future<void> selectStatus(CharacterStatus? status) =>
      tapAndPump(_statusChip(status));

  Future<void> scrollToCharacter(String id) =>
      scrollUntilFound(_card(id), scrollable: _grid);

  Future<void> scrollToBottom() => scrollToEnd(_grid);

  Future<void> openCharacter(String id) async {
    await waitFor(_card(id));
    await scrollToCharacter(id);
    await tapAndSettle(_card(id));
  }

  Future<void> retry() => tapAndPump(_retry);

  Future<void> retryNextPage() => tapAndPump(_pagingRetry);

  // Checks

  @override
  Future<void> checkScreenIsDisplayed() async {
    await waitFor(_screen);
    expect(_screen, findsOneWidget);
  }

  Future<void> checkResultsShown() async {
    await waitFor(_grid);
    expect(_grid, findsOneWidget);
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

  Future<void> checkNextPageErrorShown() async {
    await waitFor(_pagingError);
    expect(_pagingError, findsOneWidget);
  }

  void checkNoNextPage() {
    expect(_pagingLoading, findsNothing);
    expect(_pagingError, findsNothing);
  }

  void checkStatusSelected(CharacterStatus? status) {
    expect(tester.widget<ChoiceChip>(_statusChip(status)).selected, isTrue);
  }
}
