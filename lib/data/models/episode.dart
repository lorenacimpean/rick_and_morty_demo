import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    required String id,
    @Default('') String name,
    // Season and number, e.g. S01E01.
    @JsonKey(name: 'episode') @Default('') String code,
    @JsonKey(name: 'air_date') @Default('') String airDate,
  }) = _Episode;

  factory Episode.fromJson(Map<String, Object?> json) =>
      _$EpisodeFromJson(json);
}
