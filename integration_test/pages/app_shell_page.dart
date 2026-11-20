import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

import 'base_page.dart';

// Same order as the app's tabs.
enum ShellTab { characters, episodes, favorites }

class AppShellPage extends BasePage {
  const AppShellPage(super.tester);

  // Finders

  Finder get _navigationBar => find.byKey(AppKeys.shell.navigationBar);

  Finder _tab(ShellTab tab) => find.byKey(switch (tab) {
    .characters => AppKeys.shell.charactersTab,
    .episodes => AppKeys.shell.episodesTab,
    .favorites => AppKeys.shell.favoritesTab,
  });

  // Actions

  Future<void> openTab(ShellTab tab) => tapAndSettle(_tab(tab));

  // Checks

  @override
  Future<void> checkScreenIsDisplayed() async {
    await waitFor(_navigationBar);
    expect(_navigationBar, findsOneWidget);
  }

  void checkSelectedTab(ShellTab tab) {
    final bar = tester.widget<NavigationBar>(_navigationBar);
    expect(bar.selectedIndex, tab.index);
  }
}
