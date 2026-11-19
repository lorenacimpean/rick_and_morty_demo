import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_state.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_view_model.dart';
import 'package:rick_and_morty_demo/ui/shared/app_error_message.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/episode_tile.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/section_header.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({super.key});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final _viewModel = getIt<EpisodesViewModel>();

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
      child: const AppScaffold.tab(title: 'Episodes', body: _EpisodesContent()),
    );
  }
}

class _EpisodesContent extends StatelessWidget {
  const _EpisodesContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EpisodesViewModel>();
    return BlocBuilder<EpisodesViewModel, EpisodesState>(
      builder: (context, state) => switch (state) {
        EpisodesLoading() => const StateView.loading(),
        EpisodesError(:final error) => StateView.error(
          message: error.message,
          onRetry: viewModel.retry,
        ),
        EpisodesSuccess(seasons: []) => const StateView.empty(
          message: 'No episodes found',
        ),
        EpisodesSuccess(:final seasons) => _SeasonsList(seasons: seasons),
      },
    );
  }
}

class _SeasonsList extends StatelessWidget {
  final List<Season> seasons;

  const _SeasonsList({required this.seasons});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        for (final season in seasons) ...[
          SliverToBoxAdapter(
            child: SectionHeader(title: 'Season ${season.number}'),
          ),
          SliverPadding(
            padding: const .symmetric(horizontal: AppTokens.kSpacing400),
            sliver: SliverList.separated(
              itemCount: season.episodes.length,
              itemBuilder: (_, index) =>
                  _EpisodeItem(episode: season.episodes[index]),
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppTokens.kSpacing200),
            ),
          ),
        ],
        const SliverToBoxAdapter(
          child: SizedBox(height: AppTokens.kSpacing400),
        ),
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
