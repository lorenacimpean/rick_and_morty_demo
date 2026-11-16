import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_state.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_error_message.dart';
import 'package:rick_and_morty_demo/ui/shared/components/buttons/app_choice_chips.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_card.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/paging_footer.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/inputs/app_search_field.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CharactersViewModel>()..load(),
      child: const AppScaffold.tab(
        title: 'Characters',
        body: _CharactersLayout(),
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
          message: error.message,
          onRetry: viewModel.retry,
        ),
        CharactersSuccess(characters: []) => const StateView.empty(
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
  static const _kChoices = <AppChoice<CharacterStatus?>>[
    (label: 'All', value: null),
    (label: 'Alive', value: .alive),
    (label: 'Dead', value: .dead),
    (label: 'Unknown', value: .unknown),
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
        slivers: [
          SliverPadding(
            padding: const .symmetric(horizontal: AppTokens.kSpacing400),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: AppTokens.kGridCellMaxWidth,
                childAspectRatio: AppTokens.kCharacterCardAspectRatio,
                mainAxisSpacing: AppTokens.kSpacing300,
                crossAxisSpacing: AppTokens.kSpacing300,
              ),
              itemCount: state.characters.length,
              itemBuilder: (_, index) =>
                  _CharacterItem(character: state.characters[index]),
            ),
          ),
          SliverToBoxAdapter(child: _GridFooter(state: state)),
        ],
      ),
    );
  }
}

class _CharacterItem extends StatelessWidget {
  final Character character;

  const _CharacterItem({required this.character});

  @override
  Widget build(BuildContext context) {
    return CharacterCard(
      imageUrl: character.imageUrl,
      name: character.name,
      species: character.species,
      status: switch (character.status) {
        .alive => const StatusLabel.alive(),
        .dead => const StatusLabel.dead(),
        .unknown => const StatusLabel.unknown(),
      },
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
        message: pageError.message,
        onRetry: viewModel.retry,
      ),
      CharactersSuccess(isLoadingMore: true) => const PagingFooter.loading(),
      _ => const SizedBox.shrink(),
    };
  }
}
