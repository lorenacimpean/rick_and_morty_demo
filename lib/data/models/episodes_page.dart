import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/episode.dart';
import 'package:rick_and_morty_demo/data/models/page_info.dart';

part 'episodes_page.freezed.dart';
part 'episodes_page.g.dart';

@freezed
abstract class EpisodesPage with _$EpisodesPage {
  const factory EpisodesPage({
    @JsonKey(name: 'results') @Default([]) List<Episode> episodes,
    @Default(PageInfo()) PageInfo info,
  }) = _EpisodesPage;

  factory EpisodesPage.fromJson(Map<String, Object?> json) =>
      _$EpisodesPageFromJson(json);
}
