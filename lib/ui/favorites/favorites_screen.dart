import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/feedback/state_view.dart';
import 'package:rick_and_morty_demo/ui/shared/components/layout/app_scaffold.dart';

// Placeholder until the Favorites step.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold.tab(
      title: 'Favorites',
      body: StateView.empty(message: 'Coming soon'),
    );
  }
}
