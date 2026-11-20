import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

import 'base_page.dart';

class EpisodesPage extends BasePage {
  const EpisodesPage(super.tester);

  // Finders

  Finder get _screen => find.byKey(AppKeys.episodes.screen);

  Finder get _list => find.byKey(AppKeys.episodes.list);

  Finder get _error => find.byKey(AppKeys.episodes.error);

  Finder get _retry => find.byKey(AppKeys.feedback.retry);

  Finder _season(int number) => find.byKey(AppKeys.episodes.season(number));

  Finder _episode(String code) => find.byKey(AppKeys.episodes.episode(code));

  // Actions

  Future<void> scrollToSeason(int number) async {
    await waitFor(_list);
    await scrollUntilFound(_season(number), scrollable: _list);
  }

  Future<void> scrollToEpisode(String code) async {
    await waitFor(_list);
    await scrollUntilFound(_episode(code), scrollable: _list);
  }

  Future<void> retry() => tapAndPump(_retry);

  // Checks

  @override
  Future<void> checkScreenIsDisplayed() async {
    await waitFor(_screen);
    expect(_screen, findsOneWidget);
  }

  Future<void> checkSeasonShown(int number) async {
    await waitFor(_season(number));
    expect(_season(number), findsOneWidget);
  }

  Future<void> checkEpisodeShown(String code) async {
    await waitFor(_episode(code));
    expect(_episode(code), findsOneWidget);
  }

  Future<void> checkEpisodesInOrder(String first, String second) async {
    await waitFor(_episode(first));
    await waitFor(_episode(second));
    final firstTop = tester.getTopLeft(_episode(first)).dy;
    final secondTop = tester.getTopLeft(_episode(second)).dy;
    expect(firstTop, lessThan(secondTop));
  }

  Future<void> checkErrorShown() async {
    await waitFor(_error);
    expect(_error, findsOneWidget);
  }
}
