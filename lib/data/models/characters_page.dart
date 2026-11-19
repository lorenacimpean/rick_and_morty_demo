import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/data/models/page_info.dart';

part 'characters_page.freezed.dart';
part 'characters_page.g.dart';

@freezed
abstract class CharactersPage with _$CharactersPage {
  const factory CharactersPage({
    @JsonKey(name: 'results') @Default([]) List<Character> characters,
    @Default(PageInfo()) PageInfo info,
  }) = _CharactersPage;

  factory CharactersPage.fromJson(Map<String, Object?> json) =>
      _$CharactersPageFromJson(json);
}
