import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';
import 'package:rick_and_morty_demo/domain/use_cases/watch_episodes_by_season.dart';
import 'package:rick_and_morty_demo/ui/episodes/episodes_state.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

class EpisodesViewModel extends AppCubit<EpisodesState> {
  final WatchEpisodesBySeason _watchEpisodesBySeason;
  final PublishSubject<void> _loads;

  EpisodesViewModel(WatchEpisodesBySeason watchEpisodesBySeason)
    : this._(watchEpisodesBySeason, PublishSubject());

  // Private so the subject can be handed to AppCubit, which closes it.
  EpisodesViewModel._(this._watchEpisodesBySeason, this._loads)
    : super(const EpisodesState.loading(), subjects: [_loads]);

  @override
  void init() {
    // switchMap stops the failed watch when retry starts a new one.
    listenTo(
      _loads.switchMap((_) => _watchEpisodesBySeason()),
      _onSeasons,
      onError: _onError,
    );
    _loads.add(null);
  }

  void retry() {
    emit(const EpisodesState.loading());
    _loads.add(null);
  }

  void _onSeasons(List<Season> seasons) => emit(EpisodesState.success(seasons));

  void _onError(Object error) => emit(
    EpisodesState.error(
      error is AppException ? error.type : AppErrorType.generic,
    ),
  );
}
