import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/data/repos/favorites_repository.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockBox box;
  late FavoritesRepository repository;

  setUp(() {
    box = MockBox();
    repository = FavoritesRepository(box);
  });

  group('watchIds', () {
    test('emits the saved ids when listened to', () async {
      // Arrange
      when(() => box.keys).thenReturn(['1', '2']);
      when(() => box.watch()).thenAnswer((_) => const Stream.empty());

      // Act
      final stream = repository.watchIds();

      // Assert
      await expectLater(
        stream,
        emitsInOrder([
          {'1', '2'},
          emitsDone,
        ]),
      );
      verify(() => box.watch()).called(1);
    });

    test('emits the ids again after every change', () async {
      // Arrange
      var keys = ['1'];
      when(() => box.keys).thenAnswer((_) => keys);
      when(() => box.watch()).thenAnswer((_) async* {
        keys = ['1', '3'];
        yield const BoxEvent('3', true, false);
      });

      // Act
      final stream = repository.watchIds();

      // Assert
      await expectLater(
        stream,
        emitsInOrder([
          {'1'},
          {'1', '3'},
          emitsDone,
        ]),
      );
      verify(() => box.watch()).called(1);
    });

    test('ignores keys that are not strings', () async {
      // Arrange
      when(() => box.keys).thenReturn([1, 'a']);
      when(() => box.watch()).thenAnswer((_) => const Stream.empty());

      // Act
      final stream = repository.watchIds();

      // Assert
      await expectLater(stream, emits({'a'}));
      verify(() => box.watch()).called(1);
    });
  });

  group('toggle', () {
    test('saves an id that is not a favorite', () async {
      // Arrange
      when(() => box.containsKey('1')).thenReturn(false);
      when(() => box.put('1', true)).thenAnswer((_) async {});

      // Act
      await repository.toggle('1');

      // Assert
      verify(() => box.put('1', true)).called(1);
      verifyNever(() => box.delete(any<Object?>()));
    });

    test('removes an id that is a favorite', () async {
      // Arrange
      when(() => box.containsKey('1')).thenReturn(true);
      when(() => box.delete('1')).thenAnswer((_) async {});

      // Act
      await repository.toggle('1');

      // Assert
      verify(() => box.delete('1')).called(1);
      verifyNever(() => box.put(any<Object?>(), any()));
    });
  });
}
