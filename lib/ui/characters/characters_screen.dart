import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/router/app_routes.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_state.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_error_message.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';
import 'package:rick_and_morty_demo/ui/shared/components/buttons/app_choice_chips.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_grid.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/paging_footer.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/inputs/app_search_field.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final _viewModel = getIt<CharactersViewModel>();

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
    // .value: the screen owns the view model, so the provider doesn't close it.
    return BlocProvider.value(
      value: _viewModel,
      child: AppScaffold.tab(
        key: AppKeys.characters.screen,
        title: 'Characters',
        body: const _CharactersLayout(),
      ),
    );
  }
}

class _CharactersLayout extends StatelessWidget {
  const _CharactersLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .stretch,
      children: [
        _SearchBar(),
        Expanded(child: _CharactersContent()),
      ],
    );
  }
}

class _CharactersContent extends StatelessWidget {
  const _CharactersContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharactersViewModel>();
    return BlocBuilder<CharactersViewModel, CharactersState>(
      builder: (context, state) => switch (state) {
        CharactersLoading() => const StateView.loading(),
        CharactersError(:final error) => StateView.error(
          key: AppKeys.characters.error,
          message: error.message,
          onRetry: viewModel.retry,
        ),
        CharactersSuccess(characters: []) => StateView.empty(
          key: AppKeys.characters.empty,
          message: 'No characters match your search',
        ),
        final CharactersSuccess success => _CharactersGrid(state: success),
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharactersViewModel>();
    return Padding(
      padding: const .all(AppTokens.kSpacing400),
      child: Column(
        crossAxisAlignment: .start,
        spacing: AppTokens.kSpacing300,
        children: [
          AppSearchField(
            key: AppKeys.characters.searchField,
            hint: 'Search characters',
            onChanged: viewModel.search,
          ),
          const _StatusChips(),
        ],
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  static final _kChoices = <AppChoice<CharacterStatus?>>[
    (key: AppKeys.characters.allChip, label: 'All', value: null),
    (key: AppKeys.characters.aliveChip, label: 'Alive', value: .alive),
    (key: AppKeys.characters.deadChip, label: 'Dead', value: .dead),
    (key: AppKeys.characters.unknownChip, label: 'Unknown', value: .unknown),
  ];

  const _StatusChips();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharactersViewModel>();
    return BlocSelector<CharactersViewModel, CharactersState, CharacterStatus?>(
      selector: (state) => state.filter.status,
      builder: (context, status) => AppChoiceChips(
        choices: _kChoices,
        selected: status,
        onChanged: viewModel.selectStatus,
      ),
    );
  }
}

class _CharactersGrid extends StatelessWidget {
  final CharactersSuccess state;

  const _CharactersGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharactersViewModel>();
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < AppTokens.kLoadMoreDistance) {
          viewModel.loadMore();
        }
        return false;
      },
      child: CustomScrollView(
        key: AppKeys.characters.grid,
        slivers: [
          CharacterGrid(
            characters: state.characters,
            onTap: (character) => context.go(AppRoutes.character(character.id)),
          ),
          SliverToBoxAdapter(child: _GridFooter(state: state)),
        ],
      ),
    );
  }
}

class _GridFooter extends StatelessWidget {
  final CharactersSuccess state;

  const _GridFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharactersViewModel>();
    return switch (state) {
      CharactersSuccess(:final pageError?) => PagingFooter.error(
        key: AppKeys.characters.pagingError,
        message: pageError.message,
        onRetry: viewModel.retry,
      ),
      CharactersSuccess(isLoadingMore: true) => PagingFooter.loading(
        key: AppKeys.characters.pagingLoading,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
