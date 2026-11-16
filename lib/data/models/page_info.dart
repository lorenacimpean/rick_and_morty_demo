import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_info.freezed.dart';
part 'page_info.g.dart';

@freezed
abstract class PageInfo with _$PageInfo {
  // next is null on the last page.
  const factory PageInfo({int? next}) = _PageInfo;

  factory PageInfo.fromJson(Map<String, Object?> json) =>
      _$PageInfoFromJson(json);
}
