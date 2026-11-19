import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/app_list_tile.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/episode_tile.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/section_header.dart';

@AppPreview(group: 'AppListTile', name: 'Title only')
Widget appListTileTitle() => const AppListTile(title: 'Pilot');

@AppPreview(group: 'AppListTile', name: 'Subtitle and trailing')
Widget appListTileFull() => AppListTile(
  title: 'Pilot',
  subtitle: 'S01E01 · December 2, 2013',
  trailing: const Icon(Icons.chevron_right),
  onTap: () {},
);

@AppPreview(group: 'SectionHeader', name: 'Standard')
Widget sectionHeaderStandard() => const SectionHeader(title: 'Season 1');

@AppPreview(group: 'AppListTile', name: 'With leading icon')
Widget appListTileLeading() => const AppListTile(
  leading: Icon(Icons.public),
  title: 'Earth (C-137)',
  subtitle: 'Origin',
);

@AppPreview(group: 'EpisodeTile', name: 'Standard')
Widget episodeTileStandard() => EpisodeTile(
  code: 'S01E01',
  name: 'Pilot',
  airDate: 'December 2, 2013',
  onTap: () {},
);

@AppPreview(group: 'EpisodeTile', name: 'Long name')
Widget episodeTileLongName() => const EpisodeTile(
  code: 'S03E07',
  name: 'The Ricklantis Mixup, also known as Tales from the Citadel',
  airDate: 'September 10, 2017',
);
