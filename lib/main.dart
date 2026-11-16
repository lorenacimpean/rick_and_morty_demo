import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/theme/app_theme.dart';
import 'package:rick_and_morty_demo/ui/characters/characters_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.register();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // The tab router replaces home in a later step.
    return MaterialApp(
      title: 'Rick and Morty Demo',
      theme: AppTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const CharactersScreen(),
    );
  }
}
