import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../domain/models/account_entity.dart';
import '../commands/account_commands.dart';
import 'account_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class AccountCommandsViewmodel {
  final AccountStateViewModel state;
  final GetAccountCommand _getAccountCommand;
  final SaveAccountCommand _saveAccountCommand;
  final UpdateAccountCommand _updateAccountCommand;
  final DeleteAccountCommand _deleteAccountCommand;

  AccountCommandsViewmodel({
    required this.state,
    required GetAccountCommand getAccountCommand,
    required SaveAccountCommand saveAccountCommand,
    required UpdateAccountCommand updateAccountCommand,
    required DeleteAccountCommand deleteAccountCommand,
  }) : _getAccountCommand = getAccountCommand,
       _saveAccountCommand = saveAccountCommand,
       _updateAccountCommand = updateAccountCommand,
       _deleteAccountCommand = deleteAccountCommand {
    // Observers para cada comando
    _observeGetAccount();
    _observeDeleteAccount();
    _observeSaveAccount();
    _observeUpdateAccount();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  GetAccountCommand get getAccountCommand => _getAccountCommand;
  SaveAccountCommand get saveAccountCommand => _saveAccountCommand;
  UpdateAccountCommand get updateAccountCommand => _updateAccountCommand;
  DeleteAccountCommand get deleteAccountCommand => _deleteAccountCommand;

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
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
        onFailure: (err) {
          state.setMessage(err.msg); // registra o erro no estado
          if (onFailure != null) onFailure(err);
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  // Recuperar Account
  void _observeGetAccount() {
    _observeCommand<Account>(
      _getAccountCommand,
      onSuccess: (account) {
        state.setAccount(account);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // deletar Account
  void _observeDeleteAccount() {
    _observeCommand<void>(
      _deleteAccountCommand,
      onSuccess: (_) {
        state.successEvent.value = AccountSuccessEvent.deleted;
        state.setAccount(null); // Limpa a conta do estado
        
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }
 // salvar Account
  void _observeSaveAccount() {
    _observeCommand<void>(
      _saveAccountCommand,
      onSuccess: (_) {
        state.successEvent.value = AccountSuccessEvent.created;
        state.clearMessage(); // Limpa mensagens anteriores
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // atualizar Account
  void _observeUpdateAccount() {
    _observeCommand<void>(
      _updateAccountCommand,
      onSuccess: (_) {
        state.successEvent.value = AccountSuccessEvent.updated;
        state.clearMessage(); // Limpa mensagens anteriores
        
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS (CHAMADOS PELOS WIDGETS)
  //   que disparam os commands
  // ========================================================
  Future<void> fetchAccount() async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _getAccountCommand.executeWith(());
  }

  Future<void> deleteAccount() async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _deleteAccountCommand.executeWith(());
  }

  Future<void> saveAccount(Account account) async {
    state.setAccount(account); // Atualiza o estado
    await _saveAccountCommand.executeWith((account: account));
  }

  Future<void> updateAccount(Account account) async {
    state.setAccount(account); // Atualiza o estado
    await _updateAccountCommand.executeWith((account: account));
  }
}
