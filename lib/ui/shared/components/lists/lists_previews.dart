import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/app_list_tile.dart';
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
