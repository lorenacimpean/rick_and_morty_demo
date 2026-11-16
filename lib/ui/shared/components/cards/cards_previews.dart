import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_card.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';

const _kGroup = 'CharacterCard';
// Roughly one cell of a two-column grid on a phone.
const _kCardSize = Size(180, 250);

@AppPreview(group: _kGroup, name: 'Standard', size: _kCardSize)
Widget characterCardStandard() => CharacterCard(
  imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
  name: 'Rick Sanchez',
  species: 'Human',
  status: const StatusLabel.alive(),
  onTap: () {},
);

@AppPreview(group: _kGroup, name: 'Long name, broken image', size: _kCardSize)
Widget characterCardLongName() => const CharacterCard(
  imageUrl: 'https://rickandmortyapi.com/api/character/avatar/0.jpeg',
  name: 'Abradolf Lincler the Second of His Name',
  species: 'Humanoid',
  status: StatusLabel.unknown(),
);
