import '../../core/typedefs/types_defs.dart';

abstract interface class ICharacterFacadeUseCases {
  Future<ListCharacterResult> getAllCharacters(NoParams params);
  Future<CharacterResult> getCharacterById(CharacterIdParams params);
  Future<CharacterResult> saveCharacter(CharacterParams params);
  Future<CharacterResult> deleteCharacter(CharacterIdParams params);
}