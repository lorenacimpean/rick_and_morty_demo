import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_info.freezed.dart';
part 'page_info.g.dart';

@freezed
abstract class PageInfo with _$PageInfo {
  const factory PageInfo({
    // Null on the last page.
    int? next,
    // Only fetched by queries that need the total.
    @Default(1) int pages,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, Object?> json) =>
      _$PageInfoFromJson(json);
}
