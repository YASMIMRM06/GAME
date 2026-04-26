import '../../core/typedefs/types_defs.dart';
import 'character_repository_interface.dart';
import '../services/character_local_storage_interface.dart';
import '../../domain/models/character_entity.dart';

/// implementacao do repositorio de character

final class CharacterRepositoryImpl implements ICharacterRepository {
  final ICharacterLocalStorage _localStorage;

  CharacterRepositoryImpl({required ICharacterLocalStorage localStorage})
    : _localStorage = localStorage;

  @override
  Future<CharacterResult> deleteCharacter(String id) {
    return _localStorage.deleteCharacter(id);
  }

  @override
  Future<CharacterResult> getCharacterById(String id) {
    return _localStorage.getCharacterById(id);
  }

  @override
  Future<ListCharacterResult> getAllCharacters() {
    return _localStorage.getAllCharacters();
  }

  @override
  Future<CharacterResult> saveCharacter(Character character) {
    return _localStorage.saveCharacter(character);
  }
}
