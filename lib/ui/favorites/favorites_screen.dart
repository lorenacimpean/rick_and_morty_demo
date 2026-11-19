import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/router/app_routes.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_state.dart';
import 'package:rick_and_morty_demo/ui/favorites/favorites_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_error_message.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_grid.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _viewModel = getIt<FavoritesViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: AppScaffold.tab(
        key: AppKeys.favorites.screen,
        title: 'Favorites',
        body: const _FavoritesContent(),
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  const _FavoritesContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FavoritesViewModel>();
    return BlocBuilder<FavoritesViewModel, FavoritesState>(
      builder: (context, state) => switch (state) {
        FavoritesLoading() => const StateView.loading(),
        FavoritesError(:final error) => StateView.error(
          key: AppKeys.favorites.error,
          message: error.message,
          onRetry: viewModel.retry,
        ),
        FavoritesSuccess(characters: []) => StateView.empty(
          key: AppKeys.favorites.empty,
          message: 'No favorites yet. Tap the heart on a character to save it.',
        ),
        FavoritesSuccess(:final characters) => _FavoritesGrid(
          characters: characters,
        ),
      },
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<Character> characters;

  const _FavoritesGrid({required this.characters});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: AppKeys.favorites.grid,
      slivers: [
        CharacterGrid(
          characters: characters,
          // Stays in the Favorites tab, so back returns here.
          onTap: (character) =>
              context.go(AppRoutes.favoriteCharacter(character.id)),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppTokens.kSpacing400),
        ),
      ],
    );
  }
}
