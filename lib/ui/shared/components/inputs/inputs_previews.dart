import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/inputs/app_search_field.dart';

@AppPreview(group: 'AppSearchField', name: 'Standard')
Widget appSearchFieldStandard() =>
    AppSearchField(hint: 'Search characters', onChanged: (_) {});
