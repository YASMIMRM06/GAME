import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/types_defs.dart';
import '../../domain/facades/character_facade_usecases_interface.dart';
import '../../domain/models/character_entity.dart';

final class CreateCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterParams> {
  
  final ICharacterFacadeUseCases _characterFacadeUseCases;

  CreateCharacterCommand(this._characterFacadeUseCases);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar personagem.'));
    }

    return await _characterFacadeUseCases.saveCharacter(parameter!);
  }
}

final class DeleteCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterIdParams> {
  
  final ICharacterFacadeUseCases _characterFacadeUseCases;

  DeleteCharacterCommand(this._characterFacadeUseCases);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null || parameter!.id.isEmpty) {
      return Error(InputFailure('Parametro nulo para deletar personagem.'));
    }

    return await _characterFacadeUseCases.deleteCharacter(parameter!);
  }
}

final class GetAllCharactersCommand
    extends ParameterizedCommand<List<Character>, Failure, NoParams> {
  
  final ICharacterFacadeUseCases _characterFacadeUseCases;

  GetAllCharactersCommand(this._characterFacadeUseCases);

  @override
  Future<ListCharacterResult> execute() async {
    return await _characterFacadeUseCases.getAllCharacters(());
  }
}

final class GetCharacterByIdCommand
    extends ParameterizedCommand<Character, Failure, CharacterIdParams> {
  
  final ICharacterFacadeUseCases _characterFacadeUseCases;

  GetCharacterByIdCommand(this._characterFacadeUseCases);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null || parameter!.id.isEmpty) {
      return Error(InputFailure('Parametro nulo para obter personagem por ID.'));
    }

    return await _characterFacadeUseCases.getCharacterById(parameter!);
  }
}


final class UpdateCharacterCommand
    extends ParameterizedCommand<Character, Failure, CharacterParams> {

  final ICharacterFacadeUseCases _characterFacadeUseCases;

  UpdateCharacterCommand(this._characterFacadeUseCases);

  @override
  Future<CharacterResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar personagem.'));
    }

    return await _characterFacadeUseCases.saveCharacter(parameter!);
  }
}