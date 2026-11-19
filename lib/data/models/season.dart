import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';

part 'season.freezed.dart';

@freezed
abstract class Season with _$Season {
  const factory Season({required int number, required List<Episode> episodes}) =
      _Season;
}
