import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';

const _kGroup = 'StatusLabel';

@AppPreview(group: _kGroup, name: 'Alive')
Widget statusLabelAlive() => const StatusLabel.alive();

@AppPreview(group: _kGroup, name: 'Dead')
Widget statusLabelDead() => const StatusLabel.dead();

@AppPreview(group: _kGroup, name: 'Unknown')
Widget statusLabelUnknown() => const StatusLabel.unknown();
