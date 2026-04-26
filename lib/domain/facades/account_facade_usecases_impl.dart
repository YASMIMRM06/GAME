import '../../core/typedefs/types_defs.dart';
import 'account_facade_usecases_interface.dart';
import '../usecases/account_usecases_interfaces.dart';

/// implemantação do [IAccountFacadeUseCases] para
/// chamar os usecases relacionados a Account

final class AccountFacadeUsecasesImpl implements IAccountFacadeUseCases {
  final IGetAccountUseCase _getAccountUseCase;
  final ISaveAccountUseCase _saveAccountUseCase;
  final IUpdateAccountUseCase _updateAccountUseCase;
  final IDeleteAccountUseCase _deleteAccountUseCase;

  AccountFacadeUsecasesImpl({
    required IGetAccountUseCase getAccountUseCase,
    required ISaveAccountUseCase saveAccountUseCase,
    required IUpdateAccountUseCase updateAccountUseCase,
    required IDeleteAccountUseCase deleteAccountUseCase,
  }) : _getAccountUseCase = getAccountUseCase,
       _saveAccountUseCase = saveAccountUseCase,
       _updateAccountUseCase = updateAccountUseCase,
       _deleteAccountUseCase = deleteAccountUseCase;

  @override
  Future<AccountResult> getAccount(NoParams params) {
    return _getAccountUseCase(params);
  }

  @override
  Future<VoidResult> saveAccount(AccountParams params) {
    return _saveAccountUseCase(params);
  }

  @override
  Future<VoidResult> deleteAccount(NoParams params) {
    return _deleteAccountUseCase(params);
  }

  @override
  Future<VoidResult> updateAccount(AccountParams params) {
    return _updateAccountUseCase(params);
  }
}
