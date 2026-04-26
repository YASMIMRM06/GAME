import '../../domain/facades/character_facade_usecases_interface.dart';
import '../commands/character_commands.dart';
import 'characters_commands_view_model.dart';
import 'characters_state_viewmodel.dart';

// ViewModel principal que será consumida na UI
/// que mostra a lista de personagens
class CharactersViewModel {
  /// estado principal da tela, que contém a lista de personagens
  late final CharactersStateViewmodel _state;

  /// Getter público para acessar o estado de Account
  CharactersStateViewmodel get charactersState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final CharactersCommandsViewModel commands;
  CharactersViewModel(ICharacterFacadeUseCases facade) {
    _state = CharactersStateViewmodel();
    // dispara os commands e effects
    commands = CharactersCommandsViewModel(
      state: _state,
      getAccountCommand: GetAllCharactersCommand(facade),
      createCharacterCommand: CreateCharacterCommand(facade),
      deleteCharacterCommand: DeleteCharacterCommand(facade), 
      updateCharacterCommand: UpdateCharacterCommand(facade), 
     );
  }
   // --- Comandos expostos ---
  GetAllCharactersCommand get getAllCharactersCommand =>
      commands.getAllCharactersCommand; 
  CreateCharacterCommand get createCharacterCommand =>
      commands.createCharacterCommand;
  DeleteCharacterCommand get deleteCharacterCommand =>  
      commands.deleteCharacterCommand;                  
  UpdateCharacterCommand get updateCharacterCommand =>  
      commands.updateCharacterCommand;                  
}