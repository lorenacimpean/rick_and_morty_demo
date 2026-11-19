import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/place.dart';

part 'character_details.freezed.dart';
part 'character_details.g.dart';

@freezed
abstract class CharacterDetails with _$CharacterDetails {
  const factory CharacterDetails({
    required String id,
    @Default('') String name,
    @JsonKey(unknownEnumValue: CharacterStatus.unknown)
    @Default(CharacterStatus.unknown)
    CharacterStatus status,
    @Default('') String species,
    // A subspecies, often empty.
    @Default('') String type,
    @Default('') String gender,
    @JsonKey(name: 'image') @Default('') String imageUrl,
    @Default(Place()) Place origin,
    @Default(Place()) Place location,
    @JsonKey(name: 'episode') @Default([]) List<Episode> episodes,
  }) = _CharacterDetails;

  factory CharacterDetails.fromJson(Map<String, Object?> json) =>
      _$CharacterDetailsFromJson(json);
}
