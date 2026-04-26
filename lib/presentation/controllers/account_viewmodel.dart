import '../../domain/facades/account_facade_usecases_interface.dart';
import '../commands/account_commands.dart';
import 'account_commands_viewmodel.dart';
import 'account_state_viewmodel.dart';

class AccountViewModel {
  late final AccountStateViewModel _state;

  /// Getter público para acessar o estado de Account
  AccountStateViewModel get accountState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final AccountCommandsViewmodel commands;

  /// Construtor que inicializa a VieModel principal
  /// que será consumida na UI
  /// injeta a dependência do Facade dos casos de uso de Account
  /// o facade sera consumiro pelos commands

  AccountViewModel(IAccountFacadeUseCases facade) {
    _state = AccountStateViewModel();
    // dispara os commands e effects
    commands = AccountCommandsViewmodel(
      state: _state,
      saveAccountCommand: SaveAccountCommand(facade),
      updateAccountCommand: UpdateAccountCommand(facade),
      getAccountCommand: GetAccountCommand(facade),
      deleteAccountCommand: DeleteAccountCommand(facade),
    );
  }
  // --- Comandos expostos ---
  GetAccountCommand get getAccountCommand => commands.getAccountCommand;
  SaveAccountCommand get saveAccountCommand => commands.saveAccountCommand;
  DeleteAccountCommand get deleteAccountCommand =>
      commands.deleteAccountCommand;
  UpdateAccountCommand get updateAccountCommand =>
      commands.updateAccountCommand;
}
