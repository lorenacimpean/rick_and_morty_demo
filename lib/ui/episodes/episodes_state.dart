import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/season.dart';

part 'episodes_state.freezed.dart';

@freezed
sealed class EpisodesState with _$EpisodesState {
  const factory EpisodesState.loading() = EpisodesLoading;

  const factory EpisodesState.error(AppErrorType error) = EpisodesError;

  const factory EpisodesState.success(List<Season> seasons) = EpisodesSuccess;
}
