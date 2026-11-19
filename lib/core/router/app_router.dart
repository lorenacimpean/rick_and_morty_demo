import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/router/app_routes.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_screen.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_screen.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_screen.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_screen.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_shell.dart';

abstract final class AppRouter {
  static const _kIdParam = 'id';

  // Same order as the branches below.
  static const _kTabs = <AppTab>[
    (
      label: 'Characters',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
    ),
    (label: 'Episodes', icon: Icons.tv_outlined, selectedIcon: Icons.tv),
    (
      label: 'Favorites',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
    ),
  ];

  static final router = GoRouter(
    initialLocation: AppRoutes.characters,
    routes: [
      // Each tab keeps its own navigation stack and scroll position.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(
          tabs: _kTabs,
          currentIndex: shell.currentIndex,
          // Tapping the current tab again goes back to its first screen.
          onTabSelected: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          body: shell,
        ),
        branches: [
          _tab(
            AppRoutes.characters,
            const CharactersScreen(),
            routes: [_characterDetails(backTo: AppRoutes.characters)],
          ),
          _tab(AppRoutes.episodes, const EpisodesScreen()),
          _tab(
            AppRoutes.favorites,
            const FavoritesScreen(),
            routes: [_characterDetails(backTo: AppRoutes.favorites)],
          ),
        ],
      ),
    ],
  );

  // :id under a tab, so the bottom bar stays. One per tab that opens characters.
  static GoRoute _characterDetails({required String backTo}) => GoRoute(
    path: ':$_kIdParam',
    // Ids are numbers; anything else (e.g. from a deep link) goes back to the list.
    redirect: (_, state) => _characterId(state) == null ? backTo : null,
    builder: (_, state) =>
        CharacterDetailsScreen(id: _characterId(state) ?? ''),
  );

  static String? _characterId(GoRouterState state) =>
      switch (state.pathParameters[_kIdParam]) {
        final id? when int.tryParse(id) != null => id,
        _ => null,
      };

  static StatefulShellBranch _tab(
    String path,
    Widget screen, {
    List<RouteBase> routes = const [],
  }) => StatefulShellBranch(
    routes: [GoRoute(path: path, builder: (_, _) => screen, routes: routes)],
  );
}
