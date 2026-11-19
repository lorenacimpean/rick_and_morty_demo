import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_state.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_error_message.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/info_card.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/app_label.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/episode_tile.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/section_header.dart';
import 'package:rick_and_morty_demo/ui/shared/components/media/character_image.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final String id;

  const CharacterDetailsScreen({super.key, required this.id});

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late final _viewModel = getIt<CharacterDetailsViewModel>(param1: widget.id);

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
      child: const _CharacterDetailsLayout(),
    );
  }
}

class _CharacterDetailsLayout extends StatelessWidget {
  const _CharacterDetailsLayout();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CharacterDetailsViewModel>();
    return BlocBuilder<CharacterDetailsViewModel, CharacterDetailsState>(
      builder: (context, state) => AppScaffold.details(
        title: switch (state) {
          CharacterDetailsSuccess(:final character) => character.name,
          _ => '',
        },
        body: switch (state) {
          CharacterDetailsLoading() => const StateView.loading(),
          CharacterDetailsError(:final error) => StateView.error(
            message: error.message,
            onRetry: viewModel.retry,
          ),
          CharacterDetailsSuccess(:final character) => _CharacterDetailsContent(
            character: character,
          ),
        },
      ),
    );
  }
}

class _CharacterDetailsContent extends StatelessWidget {
  final CharacterDetails character;

  const _CharacterDetailsContent({required this.character});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .all(AppTokens.kSpacing400),
          sliver: SliverToBoxAdapter(child: _Profile(character: character)),
        ),
        SliverPadding(
          padding: const .symmetric(horizontal: AppTokens.kSpacing400),
          sliver: SliverToBoxAdapter(child: _Facts(character: character)),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Episodes (${character.episodes.length})',
          ),
        ),
        SliverPadding(
          padding: const .fromLTRB(
            AppTokens.kSpacing400,
            0,
            AppTokens.kSpacing400,
            AppTokens.kSpacing400,
          ),
          sliver: SliverList.separated(
            itemCount: character.episodes.length,
            itemBuilder: (_, index) =>
                _EpisodeItem(episode: character.episodes[index]),
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppTokens.kSpacing200),
          ),
        ),
      ],
    );
  }
}

class _Profile extends StatelessWidget {
  final CharacterDetails character;

  const _Profile({required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppTokens.kSpacing300,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppTokens.kDetailsImageMaxWidth,
          ),
          child: CharacterImage.rounded(url: character.imageUrl),
        ),
        Text(
          character.name,
          textAlign: .center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Wrap(
          alignment: .center,
          spacing: AppTokens.kSpacing200,
          runSpacing: AppTokens.kSpacing200,
          children: [
            AppLabel.status(character.status),
            AppLabel.text(character.species),
            AppLabel.text(character.gender),
          ],
        ),
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  final CharacterDetails character;

  const _Facts({required this.character});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      rows: [
        (icon: Icons.public, label: 'Origin', value: character.origin.name),
        (
          icon: Icons.place_outlined,
          label: 'Last known location',
          value: character.location.name,
        ),
        if (character.type.isNotEmpty)
          (icon: Icons.science_outlined, label: 'Type', value: character.type),
      ],
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final Episode episode;

  const _EpisodeItem({required this.episode});

  @override
  Widget build(BuildContext context) {
    return EpisodeTile(
      code: episode.code,
      name: episode.name,
      airDate: episode.airDate,
    );
  }
}
