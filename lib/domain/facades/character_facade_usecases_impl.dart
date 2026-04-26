import '../../core/typedefs/types_defs.dart';
import 'character_facade_usecases_interface.dart';
import '../usecases/character_usecases_interfaces.dart';

/// implementacao do [ICharacterFacadeUseCases]
/// para chamar os usecases relacionados a Character

final class CharacterFacadeUseCasesImpl implements ICharacterFacadeUseCases {
  final IGetAllCharactersUseCase _getAllCharactersUseCase;
  final IGetCharacterByIdUseCase _getCharacterByIdUseCase;
  final ISaveCharacterUseCase _saveCharacterUseCase;
  final IDeleteCharacterUseCase _deleteCharacterUseCase;

  CharacterFacadeUseCasesImpl({
    required IGetAllCharactersUseCase getAllCharactersUseCase,
    required IGetCharacterByIdUseCase getCharacterByIdUseCase,
    required ISaveCharacterUseCase saveCharacterUseCase,
    required IDeleteCharacterUseCase deleteCharacterUseCase,
  }) : _getAllCharactersUseCase = getAllCharactersUseCase,
       _getCharacterByIdUseCase = getCharacterByIdUseCase,
       _saveCharacterUseCase = saveCharacterUseCase,
       _deleteCharacterUseCase = deleteCharacterUseCase;

  @override
  Future<ListCharacterResult> getAllCharacters(NoParams params) {
    return _getAllCharactersUseCase(params);
  }

  @override
  Future<CharacterResult> getCharacterById(CharacterIdParams params) {
    return _getCharacterByIdUseCase(params);
  }

  @override
  Future<CharacterResult> saveCharacter(CharacterParams params) {
    return _saveCharacterUseCase(params);
  }

  @override
  Future<CharacterResult> deleteCharacter(CharacterIdParams params) {
    return _deleteCharacterUseCase(params);
  }
}
