import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/di/app_dependencies.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_factory.dart';
import 'package:rick_and_morty_demo/core/router/app_router.dart';
import 'package:rick_and_morty_demo/core/router/app_routes.dart';
import 'package:rick_and_morty_demo/main.dart';

import 'offline_switch_link.dart';

// The app on empty storage, against the real API until it goes offline.
class TestApp {
  // A pause before each test, so back-to-back tests don't hit the API's rate limit.
  static const _kPauseBetweenTests = Duration(seconds: 1);

  final WidgetTester _tester;
  final OfflineSwitchLink _link;

  TestApp._(this._tester, this._link);

  static Future<TestApp> start(
    WidgetTester tester, {
    bool offline = false,
  }) async {
    await Future<void>.delayed(_kPauseBetweenTests);
    final link = OfflineSwitchLink(
      HttpLink(GraphQLClientFactory.kEndpoint),
      isOffline: offline,
    );
    await _register(link);
    // deleteFromDisk only removes open boxes: open them, delete, open empty ones.
    await Hive.deleteFromDisk();
    await _register(link);
    final app = TestApp._(tester, link);
    await app._launch();
    return app;
  }

  void goOffline() => _link.isOffline = true;

  void goOnline() => _link.isOffline = false;

  // A new launch on the same storage: favorites and the cache stay.
  Future<void> restart() async {
    await _tester.pumpWidget(const SizedBox.shrink());
    await _register(_link);
    await _launch();
  }

  Future<void> _launch() async {
    // The router outlives a test, so every launch starts on the first tab.
    AppRouter.router.go(AppRoutes.characters);
    await _tester.pumpWidget(const App());
    await _tester.pump();
  }

  static Future<void> _register(Link link) async {
    await getIt.reset();
    await AppDependencies.register(link: link);
  }
}
