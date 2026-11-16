import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

class _TestCubit extends AppCubit<int> {
  _TestCubit({super.subjects}) : super(0);

  @override
  void init() {}
}

void main() {
  late _TestCubit cubit;

  setUp(() => cubit = _TestCubit());

  group('listenTo', () {
    test('passes each event to onData', () async {
      // Arrange
      final received = <int>[];

      // Act
      cubit.listenTo(Stream.fromIterable([1, 2]), received.add);
      await pumpEventQueue();

      // Assert
      expect(received, [1, 2]);
    });

    test('passes errors to onError', () async {
      // Arrange
      final errors = <Object>[];

      // Act
      cubit.listenTo(Stream<int>.error('boom'), (_) {}, onError: errors.add);
      await pumpEventQueue();

      // Assert
      expect(errors, ['boom']);
    });
  });

  group('close', () {
    test('cancels the subscriptions started with listenTo', () async {
      // Arrange
      var cancelled = false;
      final controller = StreamController<int>(
        onCancel: () => cancelled = true,
      );
      cubit.listenTo(controller.stream, (_) {});

      // Act
      await cubit.close();

      // Assert
      expect(cancelled, isTrue);
    });

    test('closes the subjects passed to the constructor', () async {
      // Arrange
      final first = PublishSubject<int>();
      final second = PublishSubject<String>();
      cubit = _TestCubit(subjects: [first, second]);

      // Act
      await cubit.close();

      // Assert
      expect((first.isClosed, second.isClosed), (true, true));
    });

    test('closes the cubit itself', () async {
      // Act
      await cubit.close();

      // Assert
      expect(cubit.isClosed, isTrue);
    });
  });
}
