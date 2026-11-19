import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';

part 'character_details_state.freezed.dart';

@freezed
sealed class CharacterDetailsState with _$CharacterDetailsState {
  const factory CharacterDetailsState.loading() = CharacterDetailsLoading;

  const factory CharacterDetailsState.error(AppErrorType error) =
      CharacterDetailsError;

  const factory CharacterDetailsState.success(
    CharacterDetails character, {
    @Default(false) bool isFavorite,
  }) = CharacterDetailsSuccess;
}
