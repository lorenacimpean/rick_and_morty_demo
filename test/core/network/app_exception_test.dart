import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';

void main() {
  group('AppException.fromOperation', () {
    AppErrorType typeFor(LinkException? link) =>
        AppException.fromOperation(OperationException(linkException: link))
            .type;

    test('maps a timeout to timeout', () {
      // Arrange
      final link = ServerException(originalException: TimeoutException(null));

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.timeout);
    });

    test('maps a network failure to noConnection', () {
      // Arrange
      final link = NetworkException(
        originalException: const SocketException('offline'),
        uri: null,
      );

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.noConnection);
    });

    test('maps a 5xx response to server', () {
      // Arrange
      const link = ServerException(statusCode: 503);

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.server);
    });

    test('maps exactly 500 to server', () {
      // Arrange
      const link = ServerException(statusCode: 500);

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.server);
    });

    test('maps a 4xx response to generic', () {
      // Arrange
      const link = ServerException(statusCode: 499);

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.generic);
    });

    test('maps a server failure without a status code to generic', () {
      // Arrange
      const link = ServerException();

      // Act
      final type = typeFor(link);

      // Assert
      expect(type, AppErrorType.generic);
    });

    test('maps GraphQL errors without a link failure to generic', () {
      // Arrange
      final exception = OperationException(
        graphqlErrors: const [GraphQLError(message: 'Query depth limit')],
      );

      // Act
      final type = AppException.fromOperation(exception).type;

      // Assert
      expect(type, AppErrorType.generic);
    });
  });
}
