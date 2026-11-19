import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_screen.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_screen.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_screen.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_shell.dart';

abstract final class AppRoutes {
  static const characters = '/characters';
  static const episodes = '/episodes';
  static const favorites = '/favorites';
}

abstract final class AppRouter {
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
          _tab(AppRoutes.characters, const CharactersScreen()),
          _tab(AppRoutes.episodes, const EpisodesScreen()),
          _tab(AppRoutes.favorites, const FavoritesScreen()),
        ],
      ),
    ],
  );

  static StatefulShellBranch _tab(String path, Widget screen) =>
      StatefulShellBranch(
        routes: [GoRoute(path: path, builder: (_, _) => screen)],
      );
}
