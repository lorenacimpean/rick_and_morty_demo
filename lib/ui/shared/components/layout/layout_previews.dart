import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';

const _kGroup = 'AppScaffold';

@AppPreview(group: _kGroup, name: 'Tab')
Widget appScaffoldTab() => const AppScaffold.tab(
  title: 'Characters',
  body: StateView.empty(message: 'Nothing here yet'),
);

@AppPreview(group: _kGroup, name: 'Details')
Widget appScaffoldDetails() => const AppScaffold.details(
  title: 'Rick Sanchez',
  body: StateView.empty(message: 'Nothing here yet'),
);

@AppPreview(group: _kGroup, name: 'Tab with pull to refresh')
Widget appScaffoldTabRefresh() => AppScaffold.tab(
  title: 'Episodes',
  onRefresh: () async {},
  body: ListView(children: const [StateView.loading()]),
);
