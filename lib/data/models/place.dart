import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

// A character's origin or last known location: only the name is fetched.
@freezed
abstract class Place with _$Place {
  const factory Place({@Default('') String name}) = _Place;

  factory Place.fromJson(Map<String, Object?> json) => _$PlaceFromJson(json);
}
