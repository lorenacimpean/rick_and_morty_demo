import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/media/character_image.dart';

const _kGroup = 'CharacterImage';
const _kUrl = 'https://rickandmortyapi.com/api/character/avatar/1.jpeg';
const _kSize = Size(200, 200);

@AppPreview(group: _kGroup, name: 'Standard', size: _kSize)
Widget characterImageStandard() => const CharacterImage.standard(url: _kUrl);

@AppPreview(group: _kGroup, name: 'Rounded', size: _kSize)
Widget characterImageRounded() => const CharacterImage.rounded(url: _kUrl);

@AppPreview(group: _kGroup, name: 'Broken image', size: _kSize)
Widget characterImageBroken() => const CharacterImage.rounded(
  url: 'https://rickandmortyapi.com/api/character/avatar/0.jpeg',
);
