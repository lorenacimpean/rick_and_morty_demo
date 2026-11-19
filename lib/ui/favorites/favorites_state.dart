import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';

part 'favorites_state.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.loading() = FavoritesLoading;

  const factory FavoritesState.error(AppErrorType error) = FavoritesError;

  const factory FavoritesState.success(List<Character> characters) =
      FavoritesSuccess;
}
