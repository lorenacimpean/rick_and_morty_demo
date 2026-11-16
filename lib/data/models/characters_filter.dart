import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

part 'characters_filter.freezed.dart';

@freezed
abstract class CharactersFilter with _$CharactersFilter {
  const factory CharactersFilter({String? name, CharacterStatus? status}) =
      _CharactersFilter;
}
