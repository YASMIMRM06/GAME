import '../../core/typedefs/types_defs.dart';
import '../../data/repositories/character_repository_interface.dart';
import 'character_usecases_interfaces.dart';

/// implementacao dos usecases relacionados a Character

/// use cases para obter personagem por id
final class GetCharacterByIdUseCaseImpl implements IGetCharacterByIdUseCase {
  final ICharacterRepository _repository;

  GetCharacterByIdUseCaseImpl({required ICharacterRepository repository})
    : _repository = repository;

  @override
  Future<CharacterResult> call(CharacterIdParams params) {
    return _repository.getCharacterById(params.id);
  }
}

/// use case para obter todos os personagens salvos
final class GetAllCharactersUseCaseImpl implements IGetAllCharactersUseCase {
  final ICharacterRepository _repository;

  GetAllCharactersUseCaseImpl({required ICharacterRepository repository})
    : _repository = repository;

  @override
  Future<ListCharacterResult> call(NoParams params) async {
     await Future.delayed(const Duration(seconds: 3));
    return _repository.getAllCharacters();
  }
}

/// use case para salvar um personagem
final class SaveCharacterUseCaseImpl implements ISaveCharacterUseCase {
  final ICharacterRepository _repository;

  SaveCharacterUseCaseImpl({required ICharacterRepository repository})
    : _repository = repository;

  @override
  Future<CharacterResult> call(CharacterParams params) async {
    await Future.delayed(const Duration(seconds: 3));
    return _repository.saveCharacter(params.character);
  }
}

/// use case para deletar um personagem
final class DeleteCharacterUseCaseImpl implements IDeleteCharacterUseCase {
  final ICharacterRepository _repository;

  DeleteCharacterUseCaseImpl({required ICharacterRepository repository})
    : _repository = repository;

  @override
  Future<CharacterResult> call(CharacterIdParams params) {
    return _repository.deleteCharacter(params.id);
  }
}
