import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/main.dart';

// Smoke test: proves the setup works on a device before the real scenarios.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens on the Characters tab', (tester) async {
    // Arrange
    await AppDependencies.register();

    // Act
    // pump, not pumpAndSettle: the loading spinner never settles.
    await tester.pumpWidget(const App());
    await tester.pump();

    // Assert
    expect(find.text('Characters'), findsWidgets);
  });
}
