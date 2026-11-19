import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

part 'character.freezed.dart';
part 'character.g.dart';

@freezed
abstract class Character with _$Character {
  const factory Character({
    required String id,
    @Default('') String name,
    @JsonKey(unknownEnumValue: CharacterStatus.unknown)
    @Default(CharacterStatus.unknown)
    CharacterStatus status,
    @Default('') String species,
    @JsonKey(name: 'image') @Default('') String imageUrl,
  }) = _Character;

  factory Character.fromJson(Map<String, Object?> json) =>
      _$CharacterFromJson(json);
}
