import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/characters_filter.dart';

part 'characters_state.freezed.dart';

@freezed
sealed class CharactersState with _$CharactersState {
  const factory CharactersState.loading({
    @Default(CharactersFilter()) CharactersFilter filter,
  }) = CharactersLoading;

  const factory CharactersState.error({
    required CharactersFilter filter,
    required AppErrorType error,
  }) = CharactersError;

  const factory CharactersState.success({
    required CharactersFilter filter,
    required List<Character> characters,
    required bool hasMore,
    // Pages on screen; loadMore asks for one more.
    required int pageCount,
    @Default(false) bool isLoadingMore,
    // A failed refresh or next page, shown under the list that's still on screen.
    AppErrorType? pageError,
  }) = CharactersSuccess;
}
