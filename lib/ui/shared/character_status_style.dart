import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

// The one place a status becomes a color and a word.
extension CharacterStatusStyle on CharacterStatus {
  Color color(ColorScheme colors) => switch (this) {
    .alive => colors.primary,
    .dead => colors.error,
    .unknown => colors.onSurfaceVariant,
  };

  String get label => switch (this) {
    .alive => 'Alive',
    .dead => 'Dead',
    .unknown => 'Unknown',
  };
}
