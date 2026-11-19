import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_state.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_view_model.dart';

import '../../mocks/mock_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  const id = '1';
  const details = MockObjects.characterDetailsMaximal;

  late MockCharactersRepository repository;

  Future<void> tick() => Future<void>.delayed(Duration.zero);

  // A factory, because retry watches the character again.
  void stubCharacter(Stream<CharacterDetails> Function() watch) =>
      when(() => repository.watchCharacter(id)).thenAnswer((_) => watch());

  setUp(() => repository = MockCharactersRepository());

  group('init', () {
    blocTest<CharacterDetailsViewModel, CharacterDetailsState>(
      'emits the character',
      build: () {
        stubCharacter(() => Stream.value(details));
        return CharacterDetailsViewModel(repository, id);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const CharacterDetailsState.success(details)],
      verify: (_) => verify(() => repository.watchCharacter(id)).called(1),
    );

    blocTest<CharacterDetailsViewModel, CharacterDetailsState>(
      'emits the error type when the character fails to load',
      build: () {
        stubCharacter(() => Stream.error(const AppException(.notFound)));
        return CharacterDetailsViewModel(repository, id);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const CharacterDetailsState.error(.notFound)],
      verify: (_) => verify(() => repository.watchCharacter(id)).called(1),
    );

    blocTest<CharacterDetailsViewModel, CharacterDetailsState>(
      'reports an unexpected error as generic',
      build: () {
        stubCharacter(() => Stream.error(Exception('boom')));
        return CharacterDetailsViewModel(repository, id);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [const CharacterDetailsState.error(.generic)],
      verify: (_) => verify(() => repository.watchCharacter(id)).called(1),
    );

    blocTest<CharacterDetailsViewModel, CharacterDetailsState>(
      'emits again when the cached character is updated',
      build: () {
        stubCharacter(
          () => Stream.fromIterable([
            MockObjects.characterDetailsMinimal,
            details,
          ]),
        );
        return CharacterDetailsViewModel(repository, id);
      },
      act: (viewModel) => viewModel.init(),
      expect: () => [
        const CharacterDetailsState.success(
          MockObjects.characterDetailsMinimal,
        ),
        const CharacterDetailsState.success(details),
      ],
      verify: (_) => verify(() => repository.watchCharacter(id)).called(1),
    );
  });

  group('retry', () {
    blocTest<CharacterDetailsViewModel, CharacterDetailsState>(
      'shows loading, then watches the character again',
      build: () {
        stubCharacter(() => Stream.error(const AppException(.noConnection)));
        return CharacterDetailsViewModel(repository, id);
      },
      act: (viewModel) async {
        viewModel.init();
        await tick();
        stubCharacter(() => Stream.value(details));
        viewModel.retry();
      },
      expect: () => [
        const CharacterDetailsState.error(.noConnection),
        const CharacterDetailsState.loading(),
        const CharacterDetailsState.success(details),
      ],
      verify: (_) => verify(() => repository.watchCharacter(id)).called(2),
    );
  });
}
