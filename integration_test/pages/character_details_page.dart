import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';
import 'package:rick_and_morty_demo/ui/shared/components/buttons/favorite_button.dart';

import 'base_page.dart';

class CharacterDetailsPage extends BasePage {
  const CharacterDetailsPage(super.tester);

  // Finders

  Finder get _screen => find.byKey(AppKeys.details.screen);

  Finder get _name => find.byKey(AppKeys.details.name);

  Finder get _favoriteButton => find.byKey(AppKeys.details.favoriteButton);

  Finder get _error => find.byKey(AppKeys.details.error);

  Finder get _retry => find.byKey(AppKeys.feedback.retry);

  Finder get _back => find.byKey(AppKeys.shell.back);

  // Actions

  Future<void> toggleFavorite() async {
    await waitFor(_favoriteButton);
    await tapAndPump(_favoriteButton);
  }

  Future<void> goBack() => tapAndSettle(_back);

  Future<void> retry() => tapAndPump(_retry);

  // Checks

  @override
  Future<void> checkScreenIsDisplayed() async {
    await waitFor(_screen);
    expect(_screen, findsOneWidget);
  }

  Future<void> checkName(String name) async {
    await waitFor(_name);
    expect(tester.widget<Text>(_name).data, name);
  }

  Future<void> checkIsFavorite(bool expected) async {
    await waitFor(_favoriteButton);
    // Saving to the box is async: wait for the heart to follow.
    await waitUntil(
      () => _isFavorite == expected,
      'waiting for favorite to be $expected',
    );
    expect(_isFavorite, expected);
  }

  Future<void> checkErrorShown() async {
    await waitFor(_error);
    expect(_error, findsOneWidget);
  }

  bool get _isFavorite =>
      tester.widget<FavoriteButton>(_favoriteButton).isFavorite;
}
