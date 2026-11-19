import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_card.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_grid.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/info_card.dart';
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

@AppPreview(group: 'InfoCard', name: 'Standard')
Widget infoCardStandard() => const InfoCard(
  rows: [
    (icon: Icons.public, label: 'Origin', value: 'Earth (C-137)'),
    (
      icon: Icons.place_outlined,
      label: 'Last known location',
      value: 'Citadel',
    ),
  ],
);

// Wide enough for two columns.
const _kGridSize = Size(420, 320);

@AppPreview(group: 'CharacterGrid', name: 'Two characters', size: _kGridSize)
Widget characterGridTwo() => CustomScrollView(
  slivers: [
    CharacterGrid(
      characters: const [
        Character(
          id: '1',
          name: 'Rick Sanchez',
          status: .alive,
          species: 'Human',
          imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        ),
        Character(
          id: '2',
          name: 'Morty Smith',
          status: .alive,
          species: 'Human',
          imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        ),
      ],
      onTap: (_) {},
    ),
  ],
);
