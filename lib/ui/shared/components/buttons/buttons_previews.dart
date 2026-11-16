import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/buttons/app_choice_chips.dart';

const _kChoices = <AppChoice<String?>>[
  (label: 'All', value: null),
  (label: 'Option A', value: 'a'),
  (label: 'Option B', value: 'b'),
];

@AppPreview(group: 'AppChoiceChips', name: 'First selected')
Widget appChoiceChipsFirst() =>
    AppChoiceChips(choices: _kChoices, selected: null, onChanged: (_) {});

@AppPreview(group: 'AppChoiceChips', name: 'Other selected')
Widget appChoiceChipsOther() =>
    AppChoiceChips(choices: _kChoices, selected: 'b', onChanged: (_) {});
