import 'package:rick_and_morty_demo/core/network/app_exception.dart';
import 'package:rick_and_morty_demo/data/models/character_details.dart';
import 'package:rick_and_morty_demo/data/repos/characters_repository.dart';
import 'package:rick_and_morty_demo/ui/character_details/character_details_state.dart';
import 'package:rick_and_morty_demo/ui/shared/app_cubit.dart';
import 'package:rxdart/rxdart.dart';

class CharacterDetailsViewModel extends AppCubit<CharacterDetailsState> {
  final CharactersRepository _repository;
  final String _id;
  final PublishSubject<void> _loads;

  CharacterDetailsViewModel(CharactersRepository repository, String id)
    : this._(repository, id, PublishSubject());

  // Private so the subject can be handed to AppCubit, which closes it.
  CharacterDetailsViewModel._(this._repository, this._id, this._loads)
    : super(const CharacterDetailsState.loading(), subjects: [_loads]);

  @override
  void init() {
    // switchMap stops the failed watch when retry starts a new one.
    listenTo(
      _loads.switchMap((_) => _repository.watchCharacter(_id)),
      _onCharacter,
      onError: _onError,
    );
    _loads.add(null);
  }

  void retry() {
    emit(const CharacterDetailsState.loading());
    _loads.add(null);
  }

  void _onCharacter(CharacterDetails character) =>
      emit(CharacterDetailsState.success(character));

  void _onError(Object error) => emit(
    CharacterDetailsState.error(
      error is AppException ? error.type : AppErrorType.generic,
    ),
  );
}
