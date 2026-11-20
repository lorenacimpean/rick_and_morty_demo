import 'dart:io';

import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/graphql_client_factory.dart';

// While offline every request fails like a lost connection; otherwise it goes to the real API.
class OfflineSwitchLink extends Link {
  final Link _online;
  bool isOffline;

  OfflineSwitchLink(this._online, {this.isOffline = false});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) =>
      isOffline ? Stream.error(_offline()) : _online.request(request, forward);

  NetworkException _offline() => NetworkException.fromException(
    originalException: const SocketException('Offline in tests'),
    originalStackTrace: StackTrace.current,
    uri: Uri.parse(GraphQLClientFactory.kEndpoint),
  );
}
