import 'dart:convert';

import '../../core/failure/failure.dart';
import '../../core/typedefs/types_defs.dart';
import 'character_local_storage_interface.dart';
import '../../domain/models/character_entity.dart';
import '../../domain/models/character_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/patterns/result.dart';

final class CharacterSharedPreferencesService
    implements ICharacterLocalStorage {
  // Chave de armazenamento para os personagens
  static const String _storageKey = 'characters';

  // antes tinha TODO e lançava UnimplementedError
  // Busca todos os personagens, remove o que tem o mesmo id e salva a lista nova
  @override
  Future<CharacterResult> deleteCharacter(String id) async {
    try {
      final currentResult = await getAllCharacters();

      return await currentResult.fold(
        onSuccess: (characters) async {
          // Encontra o personagem antes de deletar para retornar ele no sucesso
          final toDelete = characters.where((c) => c.id == id).firstOrNull;

          // Se não encontrou, retorna erro
          if (toDelete == null) {
            return Error(ApiLocalFailure('Personagem não encontrado'));
          }

          // Remove o personagem da lista pelo id
          final updatedCharacters =
              characters.where((c) => c.id != id).toList();

          // Salva a lista atualizada no storage
          await _saveCharacters(updatedCharacters);

          // Retorna o personagem deletado (o observer usa para remover da UI)
          return Success(toDelete);
        },
        onFailure: (failure) async {
          return Error(ApiLocalFailure('Erro ao deletar personagem'));
        },
      );
    } catch (e) {
      return Error(
        ApiLocalFailure('Shared Preferences - Erro ao deletar personagem: $e'),
      );
    }
  }

  @override
  Future<ListCharacterResult> getAllCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getString(_storageKey);

      if (result == null || result.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final decoded = jsonDecode(result) as List<dynamic>;

      final characters = decoded
          .map((e) => CharacterMapper.fromMap(e as Map<String, dynamic>))
          .toList();

      return Success(characters);
    } catch (e) {
      return Error(
        ApiLocalFailure('Shared Preferences - Erro ao obter personagens: $e'),
      );
    }
  }

  @override
  Future<CharacterResult> getCharacterById(String id) {
    // TODO: implement getCharacterById
    throw UnimplementedError();
  }

  // antes só adicionava, agora verifica se o id já existe
  // Se existir → atualiza (update). Se não existir → adiciona (create).
  @override
  Future<CharacterResult> saveCharacter(Character character) async {
    try {
      final currentResult = await getAllCharacters();

      return await currentResult.fold(
        onSuccess: (characters) async {
          // Verifica se já existe um personagem com o mesmo id
          final exists = characters.any((c) => c.id == character.id);

          List<Character> updatedCharacters;

          if (exists) {
            // UPDATE: substitui o personagem existente pelo novo
            updatedCharacters = characters
                .map((c) => c.id == character.id ? character : c)
                .toList();
          } else {
            // CREATE: adiciona o novo personagem na lista
            updatedCharacters = [...characters, character];
          }

          await _saveCharacters(updatedCharacters);
          return Success(character);
        },
        onFailure: (failure) async {
          if (failure is EmptyResultFailure) {
            // Lista vazia — só adiciona
            await _saveCharacters([character]);
            return Success(character);
          }

          return Error(ApiLocalFailure());
        },
      );
    } catch (e) {
      return Error(
        ApiLocalFailure('Shared Preferences - Erro ao salvar personagem: $e'),
      );
    }
  }

  /// Salva os personagens no storage
  Future<void> _saveCharacters(List<Character> characters) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(
        characters.map((c) => CharacterMapper.toMap(c)).toList(),
      );
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      throw ApiLocalFailure('Erro ao salvar personagens: $e');
    }
  }
}