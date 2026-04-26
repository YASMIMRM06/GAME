import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../domain/models/character_entity.dart';
import '../commands/character_commands.dart';
import 'characters_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CharactersCommandsViewModel {
  final CharactersStateViewmodel state;
  final GetAllCharactersCommand _getAccountCommand;
  final CreateCharacterCommand _createCharacterCommand;
  final DeleteCharacterCommand _deleteCharacterCommand;
  final UpdateCharacterCommand _updateCharacterCommand;

  CharactersCommandsViewModel({
    required this.state,
    required GetAllCharactersCommand getAccountCommand,
    required CreateCharacterCommand createCharacterCommand,
    required DeleteCharacterCommand deleteCharacterCommand,
    required UpdateCharacterCommand updateCharacterCommand,
  }) : _getAccountCommand = getAccountCommand,
       _createCharacterCommand = createCharacterCommand,
       _deleteCharacterCommand = deleteCharacterCommand,
       _updateCharacterCommand = updateCharacterCommand {
    // Observers para cada comando
    _observeGetAllCharacters();
    _observeCreateCharacter();
    _observeDeleteCharacter();
    _observeUpdateCharacter();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  GetAllCharactersCommand get getAllCharactersCommand => _getAccountCommand;
  CreateCharacterCommand get createCharacterCommand => _createCharacterCommand;
  DeleteCharacterCommand get deleteCharacterCommand => _deleteCharacterCommand;
  UpdateCharacterCommand get updateCharacterCommand => _updateCharacterCommand;

  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) Ignora até existir um resultado
      final result = command.result.value;
      if (result == null) return;

      // 3) Sucesso ou falha
      result.fold(
        onSuccess: (data) {
          state.clearMessage(); // sempre limpa erros em sucesso
          onSuccess(data); // ação específica para esse comando
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg); // registra o erro no estado
          if (onFailure != null) onFailure(err);
          command.clear();
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  /// Buscar todos os personagens
  void _observeGetAllCharacters() {
    _observeCommand<List<Character>>(
      _getAccountCommand,
      onSuccess: (characters) {
        state.clearMessage(); // Limpa mensagens anteriores
        state.state.value = characters;
      },
      onFailure: (err) =>
          state.setMessage(err.msg), // registra o erro no estado
    );
  }

  /// Criar um novo personagem
  void _observeCreateCharacter() {
    _observeCommand<Character>(
      _createCharacterCommand,
      onSuccess: (newCharacter) {
        final currentList = state.state.value;
        final newlist = [
          ...currentList,
          newCharacter,
        ]; // Adiciona o novo personagem à lista
        state.state.value = newlist;
      },
      onFailure: (err) =>
          state.setMessage(err.msg), // registra o erro no estado
    );
  }

  /// Deletar personagem — remove da lista quando o command terminar
  void _observeDeleteCharacter() {
    _observeCommand<Character>(
      _deleteCharacterCommand,
      onSuccess: (deleted) {
        // Recria a lista sem o personagem deletado (filtra pelo id)
        final newList = state.state.value
            .where((c) => c.id != deleted.id)
            .toList();
        state.state.value = newList;
      },
      onFailure: (err) =>
          state.setMessage(err.msg), // registra o erro no estado
    );
  }

  /// Atualizar personagem — substitui na lista quando o command terminar
  void _observeUpdateCharacter() {
    _observeCommand<Character>(
      _updateCharacterCommand,
      onSuccess: (updated) {
        // Percorre a lista e troca apenas o personagem com o mesmo id
        final newList = state.state.value
            .map((c) => c.id == updated.id ? updated : c)
            .toList();
        state.state.value = newList;
      },
      onFailure: (err) =>
          state.setMessage(err.msg), // registra o erro no estado
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS (CHAMADOS PELOS WIDGETS)
  //   que disparam os commands
  // ========================================================

  /// busca personagens e atualiza o estado (Botão Atualizar)
  Future<void> fetchCharacters() async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _getAccountCommand.executeWith(());
  }

  /// adiciona personagem e atualiza o estado
  Future<void> addCharacter(Character character) async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _createCharacterCommand.executeWith((character: character));
  }

  /// remove personagem e atualiza o estado (Botão Excluir)
  Future<void> deleteCharacter(String id) async {
    state.clearMessage();
    await _deleteCharacterCommand.executeWith((id: id));
  }

  /// atualiza personagem e atualiza o estado
  Future<void> updateCharacter(Character character) async {
    state.clearMessage();
    await _updateCharacterCommand.executeWith((character: character));
  }
}