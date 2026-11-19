import 'dart:async';

import 'package:graphql/client.dart';

enum AppErrorType { noConnection, timeout, notFound, server, generic }

class AppException implements Exception {
  static const _kServerErrorMin = 500;

  final AppErrorType type;

  const AppException(this.type);

  factory AppException.fromOperation(OperationException exception) =>
      AppException(_typeOf(exception.linkException));

  static AppErrorType _typeOf(LinkException? link) => switch (link) {
    LinkException(originalException: TimeoutException()) => .timeout,
    NetworkException() => .noConnection,
    ServerException(statusCode: final code?) when code >= _kServerErrorMin =>
      .server,
    _ => .generic,
  };
}
