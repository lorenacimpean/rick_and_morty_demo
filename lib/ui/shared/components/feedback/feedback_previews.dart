import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/app_preview.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';

const _kGroup = 'StateView';

@AppPreview(group: _kGroup, name: 'Loading')
Widget stateViewLoading() => const StateView.loading();

@AppPreview(group: _kGroup, name: 'Error')
Widget stateViewError() =>
    StateView.error(message: 'Something went wrong', onRetry: () {});

@AppPreview(group: _kGroup, name: 'Empty')
Widget stateViewEmpty() =>
    const StateView.empty(message: 'No characters match your search');
