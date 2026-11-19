import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/main.dart';

// Smoke test: proves the Patrol setup works before the real scenarios.
void main() {
  patrolTest('opens on the Characters tab', ($) async {
    await AppDependencies.register();
    // pumpWidget, not pumpWidgetAndSettle: the loading spinner never settles.
    await $.pumpWidget(const App());

    await $('Characters').waitUntilVisible();

    expect($('Characters'), findsWidgets);
  });
}
